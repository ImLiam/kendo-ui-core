module CodeGen::MVC6::Wrappers::Options

    GENERIC_ARGS = YAML.load(File.read("build/codegen/lib/mvc-6/config/generics.yml"))
    IGNORED_SERIALIZATION = YAML.load(File.read("build/codegen/lib/mvc-6/config/ignored_serialization.yml")).map(&:downcase)
    IGNORED_FLUENT = YAML.load(File.read("build/codegen/lib/mvc-6/config/ignored_fluent.yml")).map(&:downcase)
    NAME_MAP = YAML.load(File.read("build/codegen/lib/mvc-6/config/name_map.yml"))

    CSHARP_TYPES = {
        'Number' => 'double',
        'String' => 'string',
        'Boolean' => 'bool',
        'Date' => 'DateTime',
        'Function' => 'ClientHandlerDescriptor'
    }

    STRUCT_TYPES = [
        'int',
        'double',
        'bool',
        'DateTime'
    ]

    def component_class
        Component
    end

    def composite_option_class
        CompositeOption
    end

    def delete_ignored(ignored)
        return if @options.nil?

        @options.delete_if do |option|
            option.delete_ignored(ignored)
            ignored.include?(option.full_name)
        end
    end

    def option_class
        Option
    end

    def event_class
        Event
    end

    def array_option_class
        ArrayOption
    end

    def unique_options
        composite = composite_options.map { |o| o.name }

        f = options.find_all { |o| o.composite? || !composite.include?(o.name) }
    end

    def serialize?
        !IGNORED_SERIALIZATION.include?(full_name)
    end

    def fluent?
        !IGNORED_FLUENT.include?(full_name)
    end

    def handler?
        csharp_type.eql?('ClientHandlerDescriptor')
    end

    def template?
        name.match(/template$/i)
    end

    def dictionary?
        csharp_type.match(/^IDictionary/)
    end

    def csharp_array?
        csharp_type.match(/\[\]$/)
    end

    def csharp_name
        property_to_override = NAME_MAP != false ? NAME_MAP[full_name] : nil

        return property_to_override["name"] unless property_to_override.nil?

        name.to_csharp_name
    end

    def serialize_as
        property_to_override = NAME_MAP != false ? NAME_MAP[full_name] : nil

        return csharp_name if property_to_override.nil?

        result = property_to_override["serialize_as"]

        result
    end

    def var_name
        prefix = (name == 'virtual') ? "@" : ""

        prefix + name
    end

    def csharp_generic
        GENERIC_ARGS[full_name.split('.')[0].to_sym]
    end

    def csharp_owner_builder_name
        "#{owner.csharp_class}Builder#{owner.csharp_generic_args}"
    end

    def csharp_generic_args
        generics = csharp_generic
        return '' if generics.nil?
        '<' + generics.map { |item| item[:name] }.join(', ') + '>'
    end

    def csharp_generic_constraints
        generics = csharp_generic
        return '' if generics.nil?
        generics.map { |item| "where #{item[:name]} : #{item[:constraint]} "}.join(' ')
    end

    def builtin_names
        # check if child options contain 'name'
        name_field = options.map{ |o| o.options }.flatten.find{ |o| o.name.eql?('name') }

        return [] if name_field.nil?

        name_field.description.scan(/"(\w+)"/i).flatten
    end

    def full_name
        name = @name

        if !@owner.nil?
            name = @owner.full_name + '.' + name
        end

        name.downcase
    end

    def values
        @values if self.respond_to?(:values)
    end

    def component_name
        return @owner.component_name if !@owner.nil?

        csharp_name
    end

    def component_setter
        setter = "Container"

        if !@owner.csharp_name.eql?(component_name)
            setter += ".#{component_name}"
        end

        setter
    end

    def id_prefix
        prefix = "IdPrefix"

        if !@owner.csharp_name.eql?(component_name)
            prefix = "#{component_name}.#{prefix}"
        end

        prefix
    end

    def csharp_type
        return_type = ''

        if enum_type
            # Manually specified enum type in YML
            return_type = enum_type
        elsif values
            # Enumerable with values specified in widget YML
            return_type = "#{owner.csharp_class.gsub(/Settings/, "")}#{csharp_name}"
        elsif full_name.match(/attributes$/)
            return_type = 'IDictionary<string,object>'
        elsif type.is_a? String
            # Manually overriden type in YML
            return_type = type
        else
            # Map to C# type
            return_type = CSHARP_TYPES[type[0]]
        end

        if return_type.nil? || return_type.empty?
            raise "Unknown type mapping for #{full_name}, source type is #{type}"
        end

        return_type
    end
end