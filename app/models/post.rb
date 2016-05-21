# encoding: utf-8
class Post < ActiveRecord::Base
  include Tripcode
  include MarkdownConverter
  # Board relations
  belongs_to :board
  validates_presence_of :board, message: I18n.t('posts.errors.board_not_given')
  validate :board_existance
  has_many :users, :through => :board

  # Ancestry
  belongs_to :ancestor, class_name: 'Post'
  validate :ancestor_existance, :if => :parent_id

  # Lineage
  has_many :children, class_name: 'Post', :foreign_key => :parent_id, :dependent => :destroy
  has_many :descendants, class_name: 'Post', :foreign_key => :ancestor_id, :primary_key => :id

  # Parents
  belongs_to :parent, class_name: 'Post'
  validates_presence_of :parent, :if => :parent_id, message: I18n.t('posts.errors.presence_of_parent')
  validate :parent_existance_and_congruence, :if => :parent_id

  # Assets
  has_one :image
  accepts_nested_attributes_for :image
  validates_presence_of :image,
                        :if => :image_required?,
                        message: I18n.t('posts.errors.image_required')
  validate :check_file_size, :if => :new_record?

  # Attributes
  validates_presence_of :ip_address, message: I18n.t('posts.errors.ip_address')

  validates_length_of :subject,
                      maximum: 70,
                      message: I18n.t('posts.errors.subject_too_long', limit: 70)

  validates_length_of :body,
                      maximum: 1000,
                      message: I18n.t('posts.errors.body_too_long', limit: 1000)

  #Suspensions
  has_many :suspensions, -> { where("ends_at > ?", Date.today)}
  validate :active_suspensions

  # Reports
  has_many :reports, :dependent => :destroy

  # Routines
  before_create :set_tripcode
  before_create Proc.new { |post| post.related_id = Post.where(board_id: post.board_id).maximum(:related_id) + 1 }
  after_validation :touch_ancestor!

  after_initialize :inherit_parent, :if => :parent_id

  def as_json(options={})
    hash = super(options)
    hash['body'] = strip_markdown(hash['body'], options[:html_newlines])
    return hash
  end

  def replies
    self.descendants.count
  end

  def self.threads_for(board)
    where("parent_id IS NULL AND board_id = ?", board.id)
  end

  def self.all_threads
    where(parent_id: nil)
  end

  def worksafe?
    self.board.worksafe?
  end

  def set_tripcode
    # Is passphrase declared? Not blank? Otherwise use the post's IP address
    self.tripcode = self[:ip_address] if self[:tripcode].nil? || self[:tripcode].blank?
  end

  def tripcode_symbol
    i = self[:tripcode].hex % TRIPCODE_SYMBOLS.size
    TRIPCODE_SYMBOLS[i]
  end

  def ip_address=(ip_address)
    board_id = self.parent_id ? Post.find_by_id(self.parent_id).board_id : self.board_id
    board = Board.find_by_id(board_id)

    if board
      # Pick a random IP address if the board doesn't care.
      self[:ip_address] = board.save_IPs ? ip_address : Array.new(4){rand(256)}.join('.')
    end
  end

  def tripcode=(passphrase)
    self[:tripcode] = generate_tripcode_v2(passphrase)
  end

  # Only an ancestor can have a subject.
  def subject=(subject)
    self[:subject] = subject if self.is_ancestor?
  end

  def subject
    if self.is_ancestor?
      self[:subject] || ''
    else
      self.ancestor ? self.ancestor.subject : ''
    end
  end

  def to_sha2
    Digest::SHA2.hexdigest(SECRET_COOKIE_TOKEN + self.id.to_s)
  end

  def verify_tripcode(input)
    !input.blank? && self.tripcode == generate_tripcode(input)
  end

  def is_child?
    !self.parent_id.nil?
  end

  def is_parent?
    self.children.limit(1).any?
  end

  def is_ancestor?
    self.ancestor_id.nil?
  end

  private

  def inherit_parent
    parent = Post.find_by_id!(self.parent_id)
    self[:board_id] = parent.board_id
    self[:ancestor_id] = (parent.ancestor_id || parent.id)
  end

    def check_file_size
      if self.image
        board = Board.find_by_id(self.board_id)
        if board
          limit = board.settings(:limits).file_size_limit
          if self.image.asset.size > limit
            errors.add(:file_size_limit, I18n.t('posts.errors.file_size_limit', limit: limit))
          end
        else
          errors.add(:board_not_found, I18n.t('posts.errors.board_not_found', board_id: self.board_id))
        end
      end
    end

    def touch_ancestor!
      if self.ancestor && self.ancestor.replies <= 300
        self.ancestor.touch
      end
    end

    def ancestor_existance
      ancestor = Post.find_by_id(self.ancestor_id)
      if ancestor.nil?
        errors.add(:ancestor_existance,
                   message: I18n.t('posts.errors.ancestor_existance', ancestor_id: self.ancestor_id))
      elsif ancestor.is_ancestor? == false
        errors.add(:ancestor_not_valid,
                   message: I18n.t('posts.errors.ancestor_not_valid', ancestor_id: self.ancestor_id))
      end
    end


    # When writing this, I questioned if most of it was even necessary.
    # I don't think many of these situations would occur naturally but I would like to catch people
    # setting faulty parameters.
    def parent_existance_and_congruence
      parent = Post.find_by_id(self.parent_id)
      if parent.nil?
        errors.add(:parent_existance, I18n.t('posts.errors.parent_existance', parent_id: parent_id))

      elsif parent.board_id != self.board_id
        errors.add(:parent_ancestor_mismatch,
                   I18n.t('posts.errors.parent_board_mismatch',
                          parent_board_id: parent.board_id,
                          post_board_id: parent.board_id))

      elsif parent.is_ancestor? && (parent.id != self.ancestor_id)
        # This would occur if the reply had a ancestor that didn't match a parent who is an ancestor.
        errors.add(:parent_ancestor_mismatch,
                   I18n.t('posts.errors.parent_ancestor_mismatch', post_ancestor_id: self.ancestor_id))

      elsif (!parent.is_ancestor?) && (parent.ancestor_id != self.ancestor_id)
        errors.add(:ancestor_mismatch,
                   I18n.t('posts.errors.ancestor_mismatch',
                   parent_ancestor_id: parent.ancestor_id,
                   post_ancestor_id: self.ancestor_id))
      end
    end

    def board_existance
      unless Board.find_by_id(self.board_id)
        if self.board_id
          errors.add(:board_not_found, I18n.t('posts.errors.board_not_found', board_id: self.board_id))
        else
          errors.add(:board_existance, I18n.t('posts.errors.board_not_given'))
        end
      end
    end

    def active_suspensions
      suspensions = Suspension.where("ip_address = ? AND ends_at > ?", self.ip_address, Date.today)

      if suspensions.any?
        suspensions.each do |suspension|
          errors.add(
                :suspended, I18n.t('posts.errors.suspended',
                ends_at: suspension.ends_at,
                reason: suspension.reason))
        end
      end
    end

    # An image is required if the post is a parent
    # or if the body is blank.
    def image_required?
      if self.parent_id # post is a reply
        return self.body.blank?
      else
        return true
      end
    end
  #end_private
end
