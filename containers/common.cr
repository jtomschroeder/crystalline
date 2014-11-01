
macro alias_method(this, that)
  def {{this.id}}(*args)
    {{that.id}}(*args)
  end
end
