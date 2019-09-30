module PointCalc
  def result_calc(results)
    point = 0
    results.each do |result|
      case result.result
      when 1
        point += 100
      when 2
        point += 80
      when 3
        point += 60
      when 4
        point += 40
      when 5
        point += 20
      else
        point += 0
      end
    end
    point
  end

  def add_point(result, point)
    point += result
  end
end