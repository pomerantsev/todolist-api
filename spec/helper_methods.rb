def symbolize_keys(hash)
  hash.inject({}) do |memo, (key, value)|
    memo[key.to_sym] = value
    memo
  end
end
