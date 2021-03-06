#ifndef OPENAL_SOUND_H
#define OPENAL_SOUND_H

// ISound interface definition
#include "Sound.h"

#include <vector>
#include <AL/al.h>
#include <AL/alc.h>

using namespace std;
class COpenALSound : public ISound
{
public:
	ALuint LoadALBuffer(const string& path);
	ALuint GetWaveId(const string& path);
	void Update();
	void PlaySound(int id, float volume);
	void PlaySound(int id,CWorldObject* p,float volume);
	void PlaySound(int id,const float3& p,float volume);

	int maxSounds;
	COpenALSound();
	virtual ~COpenALSound();
private:
	int cur;
	void UpdateListener();
	void Enqueue(ALuint src);
	vector<string> LoadedFiles;
	vector<ALuint> Buffers;
	float3 posScale;
	ALuint *Sources;
};


#endif /* SOUND_H */
