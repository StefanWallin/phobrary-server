# frozen_string_literal: true

class IndexingChannel < ApplicationCable::Channel
  CHANNEL_NAME = 'indexing'

  def self.broadcast(message)
    ActionCable.server.broadcast(CHANNEL_NAME, message)
  end

  def subscribed
    stream_from CHANNEL_NAME
    ActionCable.server.broadcast(CHANNEL_NAME, 'welcome!')
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def receive(data)
    ActionCable.server.broadcast(CHANNEL_NAME, "Received: #{data}")
  end
end
