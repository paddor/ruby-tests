class K
  Foo = "foo"
  def foo; puts self.class::Foo end
end
K.new.foo

class S < K
  #Foo = "subclass"
end

S.new.foo

__END__

class NetElement
  class Telnet < Net::Telnet
    # some extensions
  end

  # some functionality for all net elements
  # but it should use the specific net element's Telnet class
end

class ISAM < NetElement
  class Telnet < NetElement::Telnet
    # more extensions
  end
  
  # specific functionality
end

class BRAS < NetElement
  class Telnet < NetElement::Telnet
    # more extensions
  end

  # specific functionality
end
