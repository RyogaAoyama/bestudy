class ResultCollection extend ActiveModel::Naming
  attr_accessor :collection

  def initialize(attributes = {}, num: 0)
    if attributes.present?
      p num
      self.collection = attributes.map{ |_, value| Result.new(result: value['result'], curriculum_id: value['curriculum_id']) }
    else
      self.collection = num.times.map{ Result.new }
    end
  end

  def save(room_id, user_id)
    collection.each do |result|
      result.room_id = room_id
      result.user_id = user_id
      result.save
    end
  end
end
