/*
creg - Code compoment registration system
Copyright 2005 Jelmer Cnossen 
*/

#ifndef jc_CR_HEADER
#define jc_CR_HEADER

#include <vector>
#include <string>

#include "ISerializer.h"

namespace creg
{
	class IType;
	class Class;
	class ClassBinder;

// -------------------------------------------------------------------
// Type/Class system
// -------------------------------------------------------------------

	// Fundamental/basic types
	enum BasicTypeID
	{
		crInt,		crUInt,
		crShort,	crUShort,
		crChar,		crUChar,
		crFloat,
		crDouble,
		crBool,
	};

	class IType
	{
	public:
		// Type interface can go here...
		virtual ~IType() {}

		virtual void Serialize (ISerializer* s, void *instance) = 0;

		static IType* CreateBasicType (BasicTypeID t);
		static IType* CreateStringType ();
		static IType* CreateObjInstanceType (Class *objectType);
		static IType* CreateEnumeratedType (size_t size);
	};

	class IMemberRegistrator
	{
	public:
		virtual void RegisterMembers (Class *cls) = 0;
	};

	enum ClassFlags {
		CF_AllowCopy = 1,   // copying is allowed
		CF_AllowLocal = 2,  // can be used as type in local script variables
		CF_Abstract = 4
	};

	struct _DummyStruct {
	};

	/** Class member flags to use with CR_MEMBER_SETFLAG */
	enum ClassMemberFlag {
		CM_NoSerialize = 1 /// Make the serializers skip the member
	};

#define _CR_CALCOFFSET(Obj, Member) \
	(unsigned int)(((char*)&(Obj)->Member)-((char*)(Obj)))

	/** Represents a C++ class or struct, declared with CR_DECLARE/CR_DECLARE_STRUCT */
	class Class
	{
	public:
		struct Member
		{
			Member();
			~Member();

			const char* name;
			IType* type;
			unsigned int offset;
			int flags; // combination of ClassMemberFlag's
		};

		struct Method
		{
			Method();
			~Method();

			const char *name;
			IType *returnval;
			std::vector<IType*> params;
		};

		Class ();
		~Class ();

		/// Returns true if this class is equal to or derived from other
		bool IsSubclassOf (Class* other);
		/// Serialize all the registered members
		void SerializeInstance (ISerializer* s, void *instance);
		void DeleteInstance (void *inst);
		/// Allocate an instance of the class
		void* CreateInstance ();
		/// Calculate a checksum from the class metadata
		void CalculateChecksum (unsigned int& checksum);
		void AddMember (const char *name, IType* type, unsigned int offset);
	//	void AddMethod (const char *name, lua_CFunction func) {}
		void SetMemberFlag (const char *name, ClassMemberFlag f);

		std::vector <Member*> members;
		std::vector <Method*> methods;
		ClassBinder* binder;
		std::string name;
		Class *base;
		void (_DummyStruct::*serializeProc)(ISerializer& s);
		void (_DummyStruct::*postLoadProc)();

		friend class ClassBinder;
	};

// -------------------------------------------------------------------
// Container Type templates
// -------------------------------------------------------------------

#include "TypeDeduction.h"

/**
 * Stores class bindings such as constructor/destructor
 */
	class ClassBinder
	{
	public:
		ClassBinder (const char *className, ClassFlags cf, ClassBinder* base, IMemberRegistrator **mreg, int instanceSize, void (*constructorProc)(void *instance), void (*destructorProc)(void *instance));

		Class *class_;
		ClassBinder *base;
		ClassFlags flags;
		IMemberRegistrator **memberRegistrator;
		const char *name;
		int size; // size of an instance in bytes
		void (*constructor)(void *instance); 
		void (*destructor)(void *instance); // needed for classes without virtual destructor (classes/structs declared with CR_DECLARE_STRUCT)

		/// Return the global list of classes
		static const std::vector<Class*>& GetClasses() { return classes; }
		/// Initialization of creg, collects all the classes and initializes metadata
		static void InitializeClasses ();
		/// Shutdown of creg
		static void FreeClasses ();
		/// Find a class by name
		static Class* GetClass(const std::string& name);

	protected:
		ClassBinder* nextBinder;

		static ClassBinder *binderList;
		static std::vector<Class*> classes;
	};

/** @def CR_DECLARE
 * Add the definitions for creg binding to the class
 * this should be put within the class definition */
#define CR_DECLARE(TCls)	public:					\
	static creg::ClassBinder binder;				\
	static creg::IMemberRegistrator *memberRegistrator;	 \
	virtual creg::Class* GetClass();				\
	inline static creg::Class *StaticClass() { return binder.class_; } \
	friend struct TCls##MemberRegistrator;

/** @def CR_DECLARE_STRUCT
 * Use this to declare a structure (POD, no vtable),
 * this should be put in the class definition, instead of CR_DECLARE */
#define CR_DECLARE_STRUCT(TStr)		public:			\
	static creg::ClassBinder binder;				\
	static creg::IMemberRegistrator *memberRegistrator;	\
	creg::Class* GetClass() { return binder.class_; }	\
	inline static creg::Class *StaticClass() { return binder.class_; } \
	friend struct TStr##MemberRegistrator;

/** @def CR_BIND_STRUCT
 * Bind a structure (POD, no vtable) declared with CR_DECLARE_STRUCT */
#define CR_BIND_STRUCT(TStr)					\
	creg::IMemberRegistrator* TStr::memberRegistrator=0;	\
	creg::ClassBinder TStr::binder(#TStr, (creg::ClassFlags)(creg::CF_AllowCopy | creg::CF_AllowLocal), 0, &TStr::memberRegistrator, sizeof(TStr), 0, 0);

/** @def CR_BIND_DERIVED
 * Bind a derived class declared with CR_DECLARE to creg
 * Should be used in the source file 
 * @param TCls class to bind
 * @param TBase base class of TCls
 */
#define CR_BIND_DERIVED(TCls, TBase)				\
	creg::IMemberRegistrator* TCls::memberRegistrator=0;	\
	creg::Class* TCls::GetClass() { return binder.class_; } \
	void TCls##ConstructInstance(void *d) { new(d) TCls; } \
	void TCls##DestructInstance(void *d) { ((TCls*)d)->~TCls(); } \
	creg::ClassBinder TCls::binder(#TCls, creg::CF_AllowLocal, &TBase::binder, &TCls::memberRegistrator, sizeof(TCls), TCls##ConstructInstance, TCls##DestructInstance);

/** @def CR_BIND
 * Bind a class not derived from CObject
 * should be used in the source file
 * @param TCls class to bind
 */
#define CR_BIND(TCls)								\
	creg::IMemberRegistrator* TCls::memberRegistrator=0;	\
	creg::Class* TCls::GetClass() { return binder.class_; } \
	void TCls##ConstructInstance(void *d) { new(d) TCls; } \
	void TCls##DestructInstance(void *d) { ((TCls*)d)->~TCls(); } \
	creg::ClassBinder TCls::binder(#TCls, creg::CF_AllowLocal, 0, &TCls::memberRegistrator, sizeof(TCls), TCls##ConstructInstance, TCls##DestructInstance);

/** @def CR_BIND_DERIVED_INTERFACE
 * Bind an abstract derived class
 * should be used in the source file
 * @param TCls abstract class to bind
 * @param TBase base class of TCls
 */
#define CR_BIND_DERIVED_INTERFACE(TCls, TBase)	\
	creg::IMemberRegistrator* TCls::memberRegistrator=0;	\
	creg::Class* TCls::GetClass() { return binder.class_; } \
	creg::ClassBinder TCls::binder(#TCls, creg::CF_Abstract, &TBase::binder, &TCls::memberRegistrator, sizeof(TCls), 0, 0);

/** @def CR_BIND_INTERFACE
 * Bind an abstract class
 * should be used in the source file
 * This simply doesn't register a constructor to creg, so you can bind non-abstract class as abstract classes as well.
 * @param TCls abstract class to bind */
#define CR_BIND_INTERFACE(TCls)	\
	creg::IMemberRegistrator* TCls::memberRegistrator=0;	\
	creg::Class* TCls::GetClass() { return binder.class_; } \
	creg::ClassBinder TCls::binder(#TCls, creg::CF_Abstract, 0, &TCls::memberRegistrator, sizeof(TCls), 0, 0);

/** @def CR_REG_METADATA
 * Binds the class metadata to the class itself
 * should be used in the source file
 * @param TClass class to register the info to
 * @param Data the metadata of the class\n
 * should consist of a series of single expression of metadata macros\n
 * for example: (CR_MEMBER(a),CR_POSTLOAD(PostLoadCallback))
 * @see CR_MEMBER
 * @see CR_ENUM_MEMBER
 * @see CR_SERIALIZER
 * @see CR_POSTLOAD
 * @see CR_MEMBER_SETFLAG
 */
#define CR_REG_METADATA(TClass, Members)				\
	struct TClass##MemberRegistrator : creg::IMemberRegistrator {\
	typedef TClass Type;						\
	TClass##MemberRegistrator() {				\
		Type::memberRegistrator=this;				\
	}												\
	void RegisterMembers(creg::Class* class_) {		\
		TClass* o=(Type*)0;						\
		Members; }									\
	} static TClass##mreg;

/** @def CR_MEMBER
 * Registers a class/struct member variable, of a type that is:
 * - a struct registered with CR_DECLARE_STRUCT/CR_BIND_STRUCT
 * - a class registered with CR_DECLARE/CR_BIND*
 * - an int,short,char,long,double,float or bool, or any of the unsigned variants of those
 * - a std::set/multiset included with STL_Set.h
 * - a std::list included with STL_List.h
 * - a std::deque included with STL_Deque.h
 * - a std::map/multimap included with STL_Map.h
 * - a std::vector
 * - a std::string
 * - an array
 * - a pointer/reference to a creg registered struct or class instance
 * For enumerated type members, @see CR_ENUM_MEMBER
 */
#define CR_MEMBER(Member) \
	class_->AddMember (#Member, creg::GetType (o->Member), _CR_CALCOFFSET(o, Member)) 

/** @def CR_ENUM_MEMBER 
 * Registers a class/struct member variable with an enumerated type */
#define CR_ENUM_MEMBER(Member) \
	class_->AddMember (#Member, creg::IType::CreateEnumeratedType(sizeof(o->Member)), (unsigned int)(((char*)&o->Member)-((char*)0)))

#define CR_METHOD(Method) \
	class_->AddMethod (#Method, creg::GetLuaWrapper(&Type::Method, o)))

/** @def CR_MEMBER_SETFLAG
 * Set a flag for a class/struct member
 * This should come after the CR_MEMBER or CR_ENUM_MEMBER for the member
 * @param Member the class member variable
 * @param Flag the class member flag @see ClassMemberFlag
 * @see ClassMemberFlag */
#define CR_MEMBER_SETFLAG(Member, Flag) \
	class_->SetMemberFlag (#Member, creg::Flag)

/** @def CR_SERIALIZER
 * Registers a custom serialization method for the class/struct
 * this function will be called when an instance is serialized.
 * There can only be one serialize method per class/struct.
 * On serialization, the registered members will be serialized first, 
 * and then this function will be called if specified
 *
 * @param SerializeFunc the serialize method, should be a member function of the class
 */
#define CR_SERIALIZER(SerializeFunc) \
	(class_->serializeProc = (void(creg::_DummyStruct::*)(creg::ISerializer&))&Type::SerializeFunc)

/** @def CR_POSTLOAD 
 * Registers a custom post-loading method for the class/struct
 * this function will be called during package loading when all serialization is finished 
 * There can only be one postload method per class/struct */
#define CR_POSTLOAD(PostLoadFunc) \
	(class_->postLoadProc = (void(creg::_DummyStruct::*)())&Type::PostLoadFunc)

class BaseObject
{
	CR_DECLARE(BaseObject);
};

};

#endif
