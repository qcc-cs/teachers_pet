require 'spec_helper'

describe TeachersPet::Actions::CreateTeams do
  include CliHelpers

  it "creates teams if none exist" do
    teams_stub = stub_get_json('https://testteacher:abc123@api.github.com/orgs/testorg/teams?per_page=100', [])

    request_stubs = []
    student_usernames.each do |student|
      request_stubs << stub_request(:post, 'https://testteacher:abc123@api.github.com/orgs/testorg/teams').
         with(body: {
           name: student,
           permission: 'push'
         }.to_json)
    end

    teachers_pet(:create_teams,
      organization: 'testorg',

      students: students_list_fixture_path,
      instructors: instructors_list_fixture_path,

      username: 'testteacher',
      password: 'abc123'
    )

    expect(teams_stub).to have_been_requested.twice
    request_stubs.each do |request_stub|
      expect(request_stub).to have_been_requested.once
    end
  end

  it "handles existing teams"
end
