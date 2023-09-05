class ApplicationController < ActionController::Base
  private 
  
  def facade
    @facade ||= MoviesFacade.new
  end
end
