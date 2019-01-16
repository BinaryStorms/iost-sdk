module IOSTSdk
  module String
    def self.camelize(str)
      str.to_s.split('_').map(&:capitalize).join
    end

    def self.classify(fq_class_name)
      fq_class_name.split('::').inject(Object) { |o, c| o.const_get c }
    end
  end
end
