# frozen_string_literal: true

module CollectionSpace
  ApiVersion = Struct.new(:status, :message, :major, :minor, :patch,
    :build, keyword_init: true) do
    def success? = status == :success

    def failure? = !success?

    def joined
      return if failure?

      [major, minor].compact.join(".")
    end
  end
end
