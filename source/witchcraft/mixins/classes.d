
module witchcraft.mixins.classes;

mixin template WitchcraftClass()
{
    import witchcraft;

    import std.meta;
    import std.traits;

    static class ClassMixin(T) : Class
    if(is(T == class))
    {
        this()
        {
            foreach(name; FieldNameTuple!T)
            {
                _fields[name] = new FieldMixin!(T, name);
            }

            foreach(name; __traits(derivedMembers, T))
            {
                static if(is(typeof(__traits(getMember, T, name)) == function))
                {
                    static if(name != "__ctor" && name != "__dtor")
                    {
                        foreach(index, overload; __traits(getOverloads, T, name))
                        {
                            _methods[name] ~= new MethodMixin!(T, name, index);
                        }
                    }
                }
            }
        }

        @property
        override Object create() const
        {
            return T.classinfo.create;
        }

        const(Attribute)[] getAttributes() const
        {
            alias attributes = AliasSeq!(__traits(getAttributes, T));
            auto values = new Attribute[attributes.length];

            foreach(index, attribute; attributes)
            {
                values[index] = new AttributeImpl!attribute;
            }

            return values;
        }

        override const(Constructor)[] getConstructors() const
        {
            static if(__traits(hasMember, T, "__ctor"))
            {
                alias constructors = AliasSeq!(__traits(getOverloads, T, "__ctor"));
                auto values = new Constructor[constructors.length];

                foreach(index, constructor; constructors)
                {
                    values[index] = new ConstructorMixin!(T, index);
                }

                return values;
            }
            else
            {
                return [ ];
            }
        }

        const(Type) getDeclaringType() const
        {
            alias Parent = Alias!(__traits(parent, T));

            static if(__traits(hasMember, Parent, "classof"))
            {
                return Parent.classof;
            }
            else
            {
                static if(is(Parent == class))
                {
                    return new ClassImpl!Parent;
                }
                else static if(is(Parent == struct))
                {
                    return new StructImpl!Parent;
                }
                else static if(is(Parent == interface))
                {
                    return new InterfaceTypeImpl!Parent;
                }
                else
                {
                    return null;
                }
            }
        }

        const(TypeInfo) getDeclaringTypeInfo() const
        {
            alias Parent = Alias!(__traits(parent, T));

            static if(__traits(compiles, typeid(Parent)))
            {
                return typeid(Parent);
            }
            else
            {
                return null;
            }
        }

        override const(InterfaceType)[] getInterfaces() const
        {
            alias Interfaces = InterfacesTuple!T;
            auto values = new InterfaceType[Interfaces.length];

            foreach(index, IFace; Interfaces)
            {
                static if(__traits(hasMember, IFace, "classof"))
                {
                    values[index] = IFace.classof;
                }
                else
                {
                    values[index] = new InterfaceTypeImpl!IFace;
                }
            }

            return values;
        }

        string getFullName() const
        {
            return fullyQualifiedName!T;
        }

        string getName() const
        {
            return T.stringof;
        }

        string getProtection() const
        {
            return __traits(getProtection, T);
        }

        override const(Class) getSuperClass() const
        {
            alias Bases = BaseClassesTuple!T;

            static if(Bases.length == 0)
            {
                return null;
            }
            else static if(__traits(hasMember, Bases[0], "classof"))
            {
                return Bases[0].classof;
            }
            else
            {
                static if(is(Bases[0] == class))
                {
                    return new ClassImpl!(Bases[0]);
                }
                else static if(is(Bases[0] == struct))
                {
                    return new StructImpl!(Bases[0]);
                }
                else static if(is(Bases[0] == interface))
                {
                    return new InterfaceTypeImpl!(Bases[0]);
                }
                else
                {
                    return null;
                }
            }
        }

        override const(TypeInfo) getSuperTypeInfo() const
        {
            alias Bases = BaseClassesTuple!T;

            static if(Bases.length > 0)
            {
                return typeid(Bases[0]);
            }
            else
            {
                return null;
            }
        }

        const(TypeInfo) getTypeInfo() const
        {
            return T.classinfo;
        }

        @property
        override bool isAbstract() const
        {
            return __traits(isAbstractClass, T);
        }

        @property
        final bool isAccessible() const
        {
            return true;
        }

        @property
        override bool isFinal() const
        {
            return __traits(isFinalClass, T);
        }
    }
}
