# frozen_string_literal: true

module IostSdk
  module Models
    require 'iost_sdk/errors'
    # Creates an instance of a model from the JSON string.
    #
    # @param model_data [Hash] the JSON string of the model data
    # @return an instance of +model_class+ if +model_data+ is valid.
    def populate(model_data:)
      # the model class is expected implement "attr_names" method
      model_attr_names = self.class.attr_names || []
      unless Set.new(model_attr_names).subset?(Set.new(model_data.keys))
        raise IostSdk::Errors::InvalidModelDataError.new(
          self.class.name,
          model_attr_names,
          model_data.keys
        )
      end
      # create the model
      model_data.each do |k, v|
        # set the instance var
        instance_variable_set("@#{k}", v)
        # define the attr_reader
        self.class.send(:define_method, k.to_sym) do
          instance_variable_get("@#{k}")
        end
      end

      self
    end
  end
end
