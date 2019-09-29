module StringTrans extend ActiveSupport::Concern

  def half_size_change(str_num)
    if str_num.is_a?(String)
      str_num.tr('０-９', '0-9')
    end
  end
  
end