class Hash
  def to_mysql_options
    collect do |k, v|
      unless v.empty?
        "--#{k}=\"#{v}\""
      else
        nil
      end
    end.reject { |a| a.nil? }.join(" ")
  end
end

class NilClass
  def empty?
    true
  end
end