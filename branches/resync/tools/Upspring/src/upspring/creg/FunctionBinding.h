/* Reflection support for functions, 
  converts a compile-time type into a runtime function description
  */

struct EmptyBinder
{
	typedef int ScriptSystem;
	static inline void Push (float v) {}
};


// Create an accessor function for a specific C function.
// The script can call this, and the accessor function will call the native function

template<typename Binder>
struct NativeFunctionBinding
{
	typedef typename Binder::State State;

};


// C++ -> script binding

template<typename Binder>

