class String
  def fixnum?
    !!(self =~ /\A[+-]?\d+\Z/)
  end
end