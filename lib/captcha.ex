defmodule Captcha do
  # allow customize receive timeout, default: 10_000
  def get(timeout \\ 1_000) do
    pid = Port.open({:spawn, Path.join(:code.priv_dir(:captcha), "captcha")}, [:binary])

    # Allow set receive timeout
    receive do
      {^pid, {:data, data}} ->
        <<text::bytes-size(5), img::binary>> = data
        {:ok, text, img}

      other ->
        other
    after
      timeout ->
        {:error, :timeout}
    end
  end
end
