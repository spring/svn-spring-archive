/*
creg - Code compoment registration system
Copyright 2005 Jelmer Cnossen 

Type matching using class templates (only class template support partial specialization)
*/

// Undefined types return 0
template<typename T>
struct DeduceType {
	IType* Get () { return IType::CreateObjInstanceType(T::StaticClass()); }
};

template<typename T>
struct IsBasicType {
	enum {Yes=0, No=1};
};

// Support for a number of fundamental types
#define CREG_SUPPORT_BASIC_TYPE(T, typeID)			\
	template <>	 struct DeduceType <T> {		\
		IType* Get () { return IType::CreateBasicType (typeID); }	\
	};																\
	template <> struct IsBasicType <T> {							\
		enum {Yes=1, No=0 };										\
	};

CREG_SUPPORT_BASIC_TYPE(int, crInt)
CREG_SUPPORT_BASIC_TYPE(unsigned int, crUInt)
CREG_SUPPORT_BASIC_TYPE(short, crShort)
CREG_SUPPORT_BASIC_TYPE(unsigned short, crUShort)
CREG_SUPPORT_BASIC_TYPE(char, crChar)
CREG_SUPPORT_BASIC_TYPE(unsigned char, crUChar)
CREG_SUPPORT_BASIC_TYPE(long, crInt) // Long is assumed to be an int (4 bytes)
CREG_SUPPORT_BASIC_TYPE(unsigned long, crUInt)
CREG_SUPPORT_BASIC_TYPE(float, crFloat)
CREG_SUPPORT_BASIC_TYPE(double, crDouble)
CREG_SUPPORT_BASIC_TYPE(bool, crBool)

struct Iterator; // Undefined Iterator struct to denote a container iterator

// vector,deque container (from script, both look like a vector)
template<typename T>
class DynamicArrayType : public IType
{
public:
	typedef typename T::iterator iterator;
	typedef typename T::value_type ElemT;

	IType *elemType;
	
	DynamicArrayType (IType *elemType) : elemType(elemType) {}
	~DynamicArrayType () { if (elemType) delete elemType; }

	void Serialize (ISerializer *s, void *inst) {
		T& ct = *(T*)inst;
		if (s->IsWriting ()) {
			int size = (int)ct.size();
			s->Serialize (&size,sizeof(int));
			for (int a=0;a<size;a++)
				elemType->Serialize (s, &ct[a]);
		} else {
			int size;
			s->Serialize (&size, sizeof(int));
			ct.resize (size);
			for (int a=0;a<size;a++)
				elemType->Serialize (s, &ct[a]);
		}
	}
};

template<typename T, int Size>
class StaticArrayType : public IType
{
public:
	IType *elemType;

	StaticArrayType(IType *et) : elemType(et) {}
	~StaticArrayType() { if (elemType) delete elemType; }

	void Serialize (ISerializer *s, void *instance)
	{
		typename T* array = (typename T*)instance;
		for (int a=0;a<Size;a++)
			elemType->Serialize (s, &array[a]);
	}
};

template<typename T>
class ObjectPointerType : public IType
{
public:
	ObjectPointerType() { objectClass = T::StaticClass(); }
	void Serialize (ISerializer *s, void *instance) {
		void **ptr = (void**)instance;
		if (s->IsWriting()) {
			T *obj = *ptr ? (T*)*ptr : 0;
			s->SerializeObjectPtr (ptr, *ptr ? ((T*)*ptr)->GetClass () : 0);
		} else s->SerializeObjectPtr (ptr, objectClass);
	}
	Class* objectClass;
};

// Pointer type
template<typename T>
struct DeduceType <T *> {
	IType* Get () { return new ObjectPointerType <T>(); }
};

// Reference type, handled as a pointer
template<typename T>
struct DeduceType <T&> {
	IType* Get () { return new ObjectPointerType <T>(); }
};

// Static array type
template<typename T, size_t ArraySize>
struct DeduceType <T[ArraySize]> {
	IType* Get () { 
		DeduceType<T> subtype;
		return new StaticArrayType <T, ArraySize> (subtype.Get());
	}
};

// Vector type (vector<T>)
template<typename T>
struct DeduceType < std::vector <T> > {
	IType* Get () { 
		DeduceType<T> elemtype;
		return new DynamicArrayType < std::vector<T> > (elemtype.Get());
	}
};

// String type
template<> struct DeduceType < std::string > {
	IType* Get () { return IType::CreateStringType (); }
};

// GetType allows to use parameter type deduction to get the template argument for DeduceType
template<typename T>
IType* GetType (T& var) {
	DeduceType<T> deduce;
	return deduce.Get();
}
