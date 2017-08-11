defmodule Expander.ExpandErrorTest do
  use ExUnit.Case, async: true

  alias Expander.ExpandError


  test "raise the correct msg when reason: :short_url_not_set" do
    assert_raise ExpandError, "expand error: expected \"short_url\" to be set", fn ->
      raise Expander.ExpandError, reason: :short_url_not_set
    end
  end

  test "raise the correct msg when reason: some_error" do
    assert_raise ExpandError, "expand error: \"some_error\"", fn ->
      raise Expander.ExpandError, reason: "some_error"
    end
  end


end
