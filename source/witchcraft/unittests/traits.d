module witchcraft.unittests.traits;

version (unittest)
{
	import witchcraft.traits;
	
	class Foo
	{
		string value;
	}

	class Bar
	{
		this(string v)
		{
			value = v;
		}

		string value;
	}
}

unittest
{
	assert(isDefaultConstructible!Foo);
	assert(!isDefaultConstructible!Bar);
}