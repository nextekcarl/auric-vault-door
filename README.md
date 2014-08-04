# Auric::Vault::Door

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'auric-vault-door'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install auric-vault-door

## Usage

@door = Auric::Vault::Door.new('shared_secret_goes_here', 'merchant_id', 'config_id', 'segment', @production_boolean?)

@door.encrypt('string_to_encrypt')
=> 'dpFAl7BY260IWzFxxxx'

@door.decrypt('dpFAl7BY260IWzFxxxx')
=> 'string_to_encrypt'

If either method fails, checking error should return a string about what went wrong:

@door.error
=> "VLT-112: This method is missing the following fields. Method: decrypt [token]"

TODO: Only encrypt and decrypt methods are currently implemented.
Better error error handling
Tests.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/auric-vault-door/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
