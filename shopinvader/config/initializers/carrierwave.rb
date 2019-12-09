CarrierWave.configure do |config|

  config.cache_dir = File.join(Rails.root, 'tmp', 'uploads')

  if ENV['STORE_ASSET_IN_S3'] == "true"
    # WARNING: add the "carrierwave-aws" gem in your Rails app Gemfile.
    # More information here: https://github.com/sorentwo/carrierwave-aws
    config.storage          = :aws
    config.aws_bucket       = ENV['S3_BUCKET']
    config.aws_acl          = 'public-read'

    config.aws_attributes = {
      cache_control: ENV['S3_CACHE_CONTROL']
    }

    config.aws_credentials  = {
      access_key_id:      ENV['S3_KEY_ID'],
      secret_access_key:  ENV['S3_SECRET_KEY'],
      region:             ENV['S3_BUCKET_REGION']
    }

    # Use a different endpoint (eg: another provider such as Exoscale)
    if ENV['S3_ENDPOINT'].present?
      # Watchout on `AWS` var name: sdk > 2.x uses `Aws`
      # https://stackoverflow.com/questions/22826432/error-uninitialized-constant-aws-nameerror
      config.aws_credentials.config = Aws.config({
        s3_endpoint: ENV['S3_ENDPOINT']
      })
    end

    # Put your CDN host below instead
    if ENV['S3_ASSET_HOST_URL'].present?
      config.asset_host = ENV['S3_ASSET_HOST_URL']
    end

  else
    # settings for the local filesystem
    config.storage = :file
    config.root = File.join(Rails.root, 'public')
  end

end
