class Module
  def alias_method_chain_with_metta(target_method, alias_suffix)
    if method_defined?("#{target_method}_with_#{alias_suffix}")
      alias_method_chain_without_metta target_method, alias_suffix
    else
      @target_method = target_method
      @alias_suffix = alias_suffix
    end
  end
  alias_method_chain :alias_method_chain, :metta
end

class << Object
  def method_added_with_metta(m)
    if m == "#{@target_method}_with_#{@alias_suffix}".to_sym
      alias_method_chain @target_method, @alias_suffix
    end
    method_added_without_metta m
  end
  alias_method_chain :method_added, :metta
end