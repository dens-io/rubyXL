require 'rubyXL/objects/ooxml_object'
require 'rubyXL/objects/container_nodes'

module RubyXL

  # http://www.schemacentral.com/sc/ooxml/e-extended-properties_Properties.html
  class DocumentProperties < OOXMLTopLevelObject
    attr_accessor :workbook

    define_child_node(RubyXL::StringNode,  :node_name => :Template)
    define_child_node(RubyXL::StringNode,  :node_name => :Manager)
    define_child_node(RubyXL::StringNode,  :node_name => :Company)
    define_child_node(RubyXL::IntegerNode, :node_name => :Pages)
    define_child_node(RubyXL::IntegerNode, :node_name => :Words)
    define_child_node(RubyXL::IntegerNode, :node_name => :Characters)
    define_child_node(RubyXL::StringNode,  :node_name => :PresentationFormat)
    define_child_node(RubyXL::IntegerNode, :node_name => :Lines)
    define_child_node(RubyXL::IntegerNode, :node_name => :Paragraphs)
    define_child_node(RubyXL::IntegerNode, :node_name => :Slides)
    define_child_node(RubyXL::IntegerNode, :node_name => :Notes)
    define_child_node(RubyXL::IntegerNode, :node_name => :TotalTime)
    define_child_node(RubyXL::IntegerNode, :node_name => :HiddenSlides)
    define_child_node(RubyXL::IntegerNode, :node_name => :MMClips)
    define_child_node(RubyXL::BooleanNode, :node_name => :ScaleCrop)
    define_child_node(RubyXL::VectorValue, :node_name => :HeadingPairs)
    define_child_node(RubyXL::VectorValue, :node_name => :TitlesOfParts)
    define_child_node(RubyXL::BooleanNode, :node_name => :LinksUpToDate)
    define_child_node(RubyXL::IntegerNode, :node_name => :CharactersWithSpaces)
    define_child_node(RubyXL::BooleanNode, :node_name => :SharedDoc)
    define_child_node(RubyXL::StringNode,  :node_name => :HyperlinkBase)
    define_child_node(RubyXL::VectorValue, :node_name => :HLinks)
    define_child_node(RubyXL::BooleanNode, :node_name => :HyperlinksChanged)
    define_child_node(RubyXL::StringNode,  :node_name => :DigSig)
    define_child_node(RubyXL::StringNode,  :node_name => :Application)
    define_child_node(RubyXL::StringNode,  :node_name => :AppVersion)
    define_child_node(RubyXL::IntegerNode, :node_name => :DocSecurity)
    set_namespaces('xmlns'    => 'http://schemas.openxmlformats.org/officeDocument/2006/extended-properties',
                   'xmlns:vt' => 'http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes')
    define_element_name 'Properties'

    def add_parts_count(name, count)
      return unless count > 0
      heading_pairs.vt_vector.vt_variant << RubyXL::Variant.new(:vt_lpstr => RubyXL::StringNode.new(:value => name))
      heading_pairs.vt_vector.vt_variant << RubyXL::Variant.new(:vt_i4 => RubyXL::IntegerNode.new(:value => count))
    end
    private :add_parts_count

    def add_part_title(name)
      titles_of_parts.vt_vector.vt_lpstr << RubyXL::StringNode.new(:value => name)
    end
    private :add_parts_count

    def before_write_xml
      if @workbook then
        self.heading_pairs = RubyXL::VectorValue.new(:vt_vector => RubyXL::Vector.new(:base_type => 'variant'))
        self.titles_of_parts = RubyXL::VectorValue.new(:vt_vector => RubyXL::Vector.new(:base_type => 'lpstr'))

        add_parts_count('Worksheets', @workbook.worksheets.size)
        @workbook.worksheets.each { |sheet| add_part_title(sheet.sheet_name) }

        if @workbook.defined_name_container then
          add_parts_count('Named Ranges', @workbook.defined_name_container.defined_names.size)
          @workbook.defined_name_container.defined_names.each { |defined_name| add_part_title(defined_name.name) }
        end
      end

      true
    end

    def self.xlsx_path
      File.join('docProps', 'app.xml')
    end

    def self.content_type
      'application/vnd.openxmlformats-officedocument.extended-properties+xml'
    end

  end


  class CoreProperties < OOXMLTopLevelObject
    attr_accessor :workbook

    define_child_node(RubyXL::StringNode,    :node_name => 'dc:creator')
    define_child_node(RubyXL::StringNode,    :node_name => 'dc:description')
    define_child_node(RubyXL::StringNode,    :node_name => 'dc:identifier')
    define_child_node(RubyXL::StringNode,    :node_name => 'dc:language')
    define_child_node(RubyXL::StringNode,    :node_name => 'dc:subject')
    define_child_node(RubyXL::StringNode,    :node_name => 'dc:title')
    define_child_node(RubyXL::StringNodeW3C, :node_name => 'dcterms:created')
    define_child_node(RubyXL::StringNodeW3C, :node_name => 'dcterms:modified')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:lastModifiedBy')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:lastPrinted')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:category')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:contentStatus')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:contentType')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:keywords')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:revision')
    define_child_node(RubyXL::StringNode,    :node_name => 'cp:version')

    set_namespaces('xmlns:cp'       => 'http://schemas.openxmlformats.org/package/2006/metadata/core-properties',
                   'xmlns:dc'       => 'http://purl.org/dc/elements/1.1/',
                   'xmlns:dcterms'  => 'http://purl.org/dc/terms/',
                   'xmlns:dcmitype' => 'http://purl.org/dc/dcmitype/',
                   'xmlns:xsi'      => 'http://www.w3.org/2001/XMLSchema-instance')
    define_element_name 'cp:coreProperties'

    def self.xlsx_path
      File.join('docProps', 'core.xml')
    end

    def self.content_type
      'application/vnd.openxmlformats-package.core-properties+xml'
    end

    def creator
      dc_creator && dc_creator.value
    end

    def creator=(v)
      self.dc_creator = RubyXL::StringNodeW3C.new(:value => v)
    end

    def modifier
      cp_last_modified_by && cp_last_modified_by.value
    end

    def modifier=(v)
      self.cp_last_modified_by = RubyXL::StringNodeW3C.new(:value => v)
    end

    def created_at
      val = dcterms_created && dcterms_created.value
      val && (val.strip.empty? ? nil : Time.parse(val))
    end

    def created_at=(v)
      self.dcterms_created = RubyXL::StringNodeW3C.new(:value => v.iso8601)
    end

    def modified_at
      val = dcterms_modified && dcterms_modified.value
      val && (val.strip.empty? ? nil : Time.parse(val))
    end

    def modified_at=(v)
      self.dcterms_modified = RubyXL::StringNodeW3C.new(:value => v.iso8601)
    end

  end

end
