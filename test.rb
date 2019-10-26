
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
end
# a = A.new
# a.error_method
 p !6.negative?
