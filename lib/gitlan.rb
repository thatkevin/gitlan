require "rubygems"
require 'uri'
require 'net/http'
require 'json'

# Utility class to make a best guess of languages for a Github user
class Gitlan

  # Fetches a JSON response for the given URL
  # Params:
  # +url+:: The URL
  def fetch_json_response(url:)

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url.request_uri)
    if ENV.has_key? 'GITHUB_ACCESS_TOKEN'
      request['Authorization'] = ENV['GITHUB_ACCESS_TOKEN']
    end

    res = http.request(request)

    # no response received
    if(!res.is_a?(Net::HTTPSuccess))
      raise StandardError.new('Could not fetch ' + url.to_s +
        '. You can set the GITHUB_ACCESS_TOKEN environment variable - fetch a new token at ' +
        'https://github.com/settings/tokens/new?scopes=repo&description=Gitlan_utility')
    end

    json_response = res.body
    JSON.parse(json_response)
  end

  def repos_url(username)
    URI('https://api.github.com/users/' + username + '/repos')
  end

  def fetch_languages(username:)
    # clean username - strip non alpha numeric
    username = username.gsub(/[^0-9a-z]/i, '')

    # fetch for this user
    repos = fetch_json_response(url: repos_url(username))

    # fetched langs
    languages = {}

    # loop each repo
    repos.each do |repo|
      repo_full_name = repo['full_name']
      repo_lang = repo['language']

      # if there is no language, continue loop
      if repo_lang.nil?
        next
      end

      # add to the languages count
      if languages.has_key? repo_lang
        languages[repo_lang] = languages[repo_lang] += 1
      else
        languages[repo_lang] = 0
      end
    end

    # return largest values key
    languages.max_by{|k,v| v}[0]
  end
end
