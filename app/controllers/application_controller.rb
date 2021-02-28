# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def log_exception(klass, exception)
    msg = exception.message
    Rails.logger.info "#{klass}: Caught error: #{exception} for message #{msg}."
    exception.backtrace.each { |line| Rails.logger.info "#{klass}: #{line}" }
  end
end
