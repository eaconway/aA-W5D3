require 'active_support'
require 'active_support/core_ext'
require 'erb'
require_relative './session'

class ControllerBase
  attr_reader :req, :res, :params

  # Setup the controller
  def initialize(req, res)
    @already_built_response = false
    @req = req
    @res = res
  end

  # Helper method to alias @already_built_response
  def already_built_response?
    @already_built_response
  end

  # Set the response status code and header
  def redirect_to(url)
    raise 'whatever' if already_built_response?
    @already_built_response = true
    
    @res.status = 302
    @res['Location'] = url
  end

  # Populate the response with content.
  # Set the response's content type to the given type.
  # Raise an error if the developer tries to double render.
  def render_content(content, content_type = 'text/html')
    raise 'whatever' if already_built_response?
    @already_built_response = true

    @res.write(content)
    @res['Content-Type'] = content_type
  end

  # use ERB and binding to evaluate templates
  # pass the rendered html to render_content
  def render(template_name)
    # dir_path = File.dirname(__FILE__).to_s.split("/")[0..-2].join("/")
    # controller = self.class.to_s.split(/(?=[A-Z])/).join("_").downcase
    dir_path = File.dirname(__FILE__)
    
    # template_path = File.join(dir_path, "views/#{controller}", "#{template_name}.html.erb")
    template_path = File.join(dir_path, "..", "views", self.class.name.underscore, "#{template_name}.html.erb")
    template_code = File.read(template_path)
    render_content(ERB.new(template_code).result(binding))
  end

  # method exposing a `Session` object
  def session
    
  end

  # use this with the router to call action_name (:index, :show, :create...)
  def invoke_action(name)
  end
end

