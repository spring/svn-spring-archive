// *** This is a generated file; if you want to change it, please change CSAIInterfaces.dll, which is the reference
// 
// This file was generated by ABICCodeGenerator, by Hugh Perkins hughperkins@gmail.com http://manageddreams.com
// 
AICALLBACK_API float IAICallback_GetEnergyUsage( const IAICallback *self );
AICALLBACK_API float IAICallback_GetEnergyStorage( const IAICallback *self );
AICALLBACK_API float IAICallback_GetFeatureHealth( const IAICallback *self, int feature );
AICALLBACK_API float IAICallback_GetFeatureReclaimLeft( const IAICallback *self, int feature );
AICALLBACK_API int IAICallback_GetNumUnitDefs( const IAICallback *self );
AICALLBACK_API float IAICallback_GetUnitDefRadius( const IAICallback *self, int def );
AICALLBACK_API float IAICallback_GetUnitDefHeight( const IAICallback *self, int def );
AICALLBACK_API void IAICallback_SendTextMsg( const IAICallback *self, char * text, int priority );
AICALLBACK_API const UnitDef * IAICallback_GetUnitDef( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_CreateGroup( const IAICallback *self, char * dll, int aiNumber );
AICALLBACK_API void IAICallback_EraseGroup( const IAICallback *self, int groupid );
AICALLBACK_API const char * IAICallback_GetModName( const IAICallback *self );
AICALLBACK_API const char * IAICallback_GetMapName( const IAICallback *self );
AICALLBACK_API void IAICallback_SetFigureColor( const IAICallback *self, int group, float red, float green, float blue, float alpha );
AICALLBACK_API void IAICallback_DeleteFigureGroup( const IAICallback *self, int group );
AICALLBACK_API int IAICallback_GetCurrentFrame( const IAICallback *self );
AICALLBACK_API int IAICallback_GetMyTeam( const IAICallback *self );
AICALLBACK_API int IAICallback_GetMyAllyTeam( const IAICallback *self );
AICALLBACK_API int IAICallback_GetPlayerTeam( const IAICallback *self, int player );
AICALLBACK_API bool IAICallback_AddUnitToGroup( const IAICallback *self, int unitid, int groupid );
AICALLBACK_API bool IAICallback_RemoveUnitFromGroup( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_GetUnitGroup( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_GetUnitAiHint( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_GetUnitTeam( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_GetUnitAllyTeam( const IAICallback *self, int unitid );
AICALLBACK_API float IAICallback_GetUnitHealth( const IAICallback *self, int unitid );
AICALLBACK_API float IAICallback_GetUnitMaxHealth( const IAICallback *self, int unitid );
AICALLBACK_API float IAICallback_GetUnitSpeed( const IAICallback *self, int unitid );
AICALLBACK_API float IAICallback_GetUnitPower( const IAICallback *self, int unitid );
AICALLBACK_API float IAICallback_GetUnitExperience( const IAICallback *self, int unitid );
AICALLBACK_API float IAICallback_GetUnitMaxRange( const IAICallback *self, int unitid );
AICALLBACK_API bool IAICallback_IsUnitActivated( const IAICallback *self, int unitid );
AICALLBACK_API bool IAICallback_UnitBeingBuilt( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_GetBuildingFacing( const IAICallback *self, int unitid );
AICALLBACK_API bool IAICallback_IsUnitCloaked( const IAICallback *self, int unitid );
AICALLBACK_API bool IAICallback_IsUnitParalyzed( const IAICallback *self, int unitid );
AICALLBACK_API int IAICallback_GetMapWidth( const IAICallback *self );
AICALLBACK_API int IAICallback_GetMapHeight( const IAICallback *self );
AICALLBACK_API float IAICallback_GetMaxMetal( const IAICallback *self );
AICALLBACK_API float IAICallback_GetExtractorRadius( const IAICallback *self );
AICALLBACK_API float IAICallback_GetMinWind( const IAICallback *self );
AICALLBACK_API float IAICallback_GetMaxWind( const IAICallback *self );
AICALLBACK_API float IAICallback_GetTidalStrength( const IAICallback *self );
AICALLBACK_API float IAICallback_GetGravity( const IAICallback *self );
AICALLBACK_API float IAICallback_GetElevation( const IAICallback *self, float x, float z );
AICALLBACK_API float IAICallback_GetMetal( const IAICallback *self );
AICALLBACK_API float IAICallback_GetMetalIncome( const IAICallback *self );
AICALLBACK_API float IAICallback_GetMetalUsage( const IAICallback *self );
AICALLBACK_API float IAICallback_GetMetalStorage( const IAICallback *self );
AICALLBACK_API float IAICallback_GetEnergy( const IAICallback *self );
AICALLBACK_API float IAICallback_GetEnergyIncome( const IAICallback *self );
