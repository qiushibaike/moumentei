module IPService
  module_function
  def ip2long(ip)
    a = 0
    b = 24
    ip.split('.').each do |c|
      a += (c.to_i << b)
      b -= 8
    end
    a
  end

  def long2ip(ip)
    a = []
    while ip > 0
      a << (ip & 0xFF)
      ip >>= 8
    end
    a.reverse.join('.')
  end
end