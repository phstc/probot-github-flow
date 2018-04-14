
- auto add webhook
- auto add labels in progress, ready for review, Constants::REJECTED, review requested
- auto remove in progress when ready for review or Constants::REJECTED
- auto remove in progress and add ready for review when review requested
- auto remove in progress, ready for review, review requested when closed
- auto assign when fixes in a PR

```shell
bundle install
bundle exec dotenv shotgun -p 4567
```

# basics-of-authentication

This is the sample project built by following the "[Basics of Authentication][basics of auth]"
guide on developer.github.com.

It consists of two different servers: one built correctly, and one built less optimally.

## Install and Run project

To run these projects, make sure you have [Bundler][bundler] installed; then type
`bundle install` on the command line.

For the "less optimal" server, type `ruby server.rb` on the command line.

For the correct server, enter `ruby advanced_server.rb` on the command line.

Both commands will run the server at `localhost:4567`.

[basics of auth]: http://developer.github.com/guides/basics-of-authentication/
[bundler]: http://gembundler.com/
