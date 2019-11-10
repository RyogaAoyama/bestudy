
class A
  def error_method
    if true
      test_method
    end
    p 'mazika'
    rescue
      p 'error'
  end

  def test_method
    a = 1/0
  end

  def a_method(str)
    return str
  end
end
# a = A.new
# a.error_method

a = A.new

p "hello#{ a.a_method("aaa")}"
if a&.b_method?
  p 'true'
else
  p 'false'
end
