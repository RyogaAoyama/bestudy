
class A
  def error_method
    test_method
    rescue
      p 'error'
    p 'mazika'
  end

  def test_method
    a = 1/0
  end
end
def void(a)
  p a
end

true && void("aa")