defmodule UUID5Test do
  use ExUnit.Case, async: true

  doctest UUID5

  # Hyphens in the right places, not one hexadecimal character.
  @shaped "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz"
  @uuid "6ba7b810-9dad-11d1-80b4-00c04fd430c8"

  describe "cast/1" do
    test "accepts a uuid" do
      assert {:ok, @uuid} == UUID5.cast(@uuid)
    end

    test "accepts a uuid in upper case, unchanged" do
      upper = String.upcase(@uuid)

      assert {:ok, upper} == UUID5.cast(upper)
    end

    test "accepts what generate/0 produces" do
      uuid = UUID5.generate()

      assert {:ok, uuid} == UUID5.cast(uuid)
    end

    test "refuses a value of the wrong length" do
      assert :error == UUID5.cast("6ba7b810-9dad-11d1-80b4")
    end

    test "refuses a term that is not a binary" do
      assert :error == UUID5.cast(nil)
      assert :error == UUID5.cast(42)
    end
  end

  describe "dump/1" do
    test "converts a uuid to sixteen bytes" do
      assert {:ok, binary} = UUID5.dump(@uuid)
      assert byte_size(binary) == 16
    end

    test "answers :error for a value it cannot convert, rather than raising" do
      assert :error == UUID5.dump(@shaped)
    end

    test "answers :error for a term that is not a uuid string" do
      assert :error == UUID5.dump("")
      assert :error == UUID5.dump(nil)
    end
  end

  describe "load/1" do
    test "converts sixteen bytes back to a uuid" do
      {:ok, binary} = UUID5.dump(@uuid)

      assert {:ok, @uuid} == UUID5.load(binary)
    end

    test "refuses anything else" do
      assert :error == UUID5.load(<<1, 2, 3>>)
    end
  end
end
