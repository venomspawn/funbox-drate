# frozen_string_literal: true

# Base class of controller classes
class ApplicationController < ActionController::Base
  # Gets a call when a subclass inherits the class
  # @param [Class] controller_class
  #   the subclass
  def self.inherited(controller_class)
    controller_class.setup_view_paths
  end

  # Returns relative path to directory constructed from namespace of the class
  # @example
  #   Events::CreationController.namespace_dir ~> 'events'
  #   Events::SomeModule::IndexController.namespace_dir ~> 'events/some_module'
  # @return [String]
  #   resulting path
  def self.namespace_dir
    to_s.deconstantize.underscore
  end

  # Path to views
  VIEWS_PATH = Rails.root.join('app', 'views').freeze

  # Returns absolute path to views
  # @return [Pathname]
  #   resulting path
  def self.views_path
    VIEWS_PATH.join(namespace_dir)
  end

  # Pattern for template path look ups
  TEMPLATE_PATH_PATTERN = ':action.html.erb'

  # Returns resolver of view files
  # @return [ActionView::FileSystemResolver]
  #   resulting resolver
  def self.views_resolver
    ActionView::FileSystemResolver.new(views_path, TEMPLATE_PATH_PATTERN)
  end

  # Path to layouts directory
  LAYOUT_PATH = VIEWS_PATH.join('layouts').freeze

  # Returns resolver of layout files
  # @return [ActionView::FileSystemResolver]
  #   resulting resolver
  def self.layout_resolver
    ActionView::FileSystemResolver.new(LAYOUT_PATH, TEMPLATE_PATH_PATTERN)
  end

  # Sets up template look up paths accordingly to namespace of the controller
  # class and template path patterns to {TEMPLATE_PATH_PATTERN}
  # @example
  #   Events::CreationController.setup_view_paths sets up
  #   `<root>/app/views/events` and `<root>/app/views/layouts` as the paths for
  #   templates look ups
  def self.setup_view_paths
    self.view_paths = [views_resolver, layout_resolver]
  end

  # Returns yielded value or provided default value if an exception is raised
  # @return [Object]
  #   resulting value
  def yield_safely(default = nil)
    yield
  rescue StandardError
    default
  end

  helper_method :yield_safely
end
