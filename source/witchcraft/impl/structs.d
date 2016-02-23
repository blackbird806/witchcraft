
module witchcraft.impl.structs;

import witchcraft;

template StructImpl(T)
{
    static if(__traits(getProtection, T) == "public")
    {
        // In this context, use field-impl.
        template FieldMixin(T, string name)
        {
            alias FieldMixin = FieldImpl!(T, name);
        }

        // In this context, use method-impl.
        template MethodMixin(T, string name, size_t overload)
        {
            alias MethodMixin = MethodImpl!(T, name, overload);
        }

        mixin WitchcraftStruct;

        alias StructImpl = StructMixin!T;
    }
    else
    {
        class StructImpl : Struct
        {
            const(Attribute)[] getAttributes() const
            {
                assert(0, "Struct " ~ T.stringof ~ " is inaccessible.");
            }

            override const(Constructor)[] getConstructors() const
            {
                assert(0, "Struct " ~ T.stringof ~ " is inaccessible.");
            }

            const(Type) getDeclaringType() const
            {
                assert(0, "Struct " ~ T.stringof ~ " is inaccessible.");
            }

            const(TypeInfo) getDeclaringTypeInfo() const
            {
                assert(0, "Struct " ~ T.stringof ~ " is inaccessible.");
            }

            string getFullName() const
            {
                assert(0, "Struct " ~ T.stringof ~ " is inaccessible.");
            }

            string getName() const
            {
                return T.stringof;
            }

            string getProtection() const
            {
                return __traits(getProtection, T);
            }

            const(TypeInfo) getTypeInfo() const
            {
                assert(0, "Struct " ~ T.stringof ~ " is inaccessible.");
            }

            @property
            final bool isAccessible() const
            {
                return false;
            }
        }
    }
}
