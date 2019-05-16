# frozen_string_literal: true

require 'rails_helper'

describe 'rake auth:create', type: :task do
  it 'includes :environment as a prerequisite' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'creates a profile for the name argument' do
    user_name = 'foo_user'
    expect(Profile.count).to eq(0)
    expect { task.execute(to_task_arguments(user_name)) }.to output.to_stdout_from_any_process
    expect(Profile.find_by(name: user_name)).not_to eq(nil)
  end

  it 'creates a auth_attempt for the named profile' do
    user_name = 'foo_user'
    expect(AuthAttempt.count).to eq(0)
    expect { task.execute(to_task_arguments(user_name)) }.to output.to_stdout_from_any_process
    expect { task.execute(to_task_arguments(user_name)) }.to output.to_stdout_from_any_process
    profile = Profile.find_by(name: user_name)
    expect(profile.auth_attempts.last).not_to eq(nil)
  end

  it 'outputs usage instructions for the profile' do
    user_name = 'foo_user'
    allow_any_instance_of(AuthAttempt).to receive(:secret).and_return('barbaz')
    expect($stdout).to receive(:puts).with(/Hi #{user_name},/i)
    expect($stdout).to receive(:puts).with(/your auth code is: barbaz/i)
    expect($stdout).to receive(:puts).with(/and it expires:/i)
    expect($stdout).to receive(:puts).with(/ /i) # QR code, hard to test!

    task.execute(to_task_arguments(user_name))
  end

  it 'errors without a profile name argument' do
    expect($stderr).to receive(:puts).with(/Missing name argument/i)
    task.execute(to_task_arguments(nil))
  end
end
