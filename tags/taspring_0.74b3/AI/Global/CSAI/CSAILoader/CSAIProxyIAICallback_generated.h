// *** This is a generated file; if you want to change it, please change GlobalAIInterfaces.dll, which is the reference
// 
// This file was generated by CSAIProxyGenerator, by Hugh Perkins hughperkins@gmail.com http://manageddreams.com
// 
   double GetEnergyUsage(  )
   {
      return self->GetEnergyUsage(   );
   }

   double GetEnergyStorage(  )
   {
      return self->GetEnergyStorage(   );
   }

   double GetFeatureHealth( int feature )
   {
      return self->GetFeatureHealth( feature  );
   }

   double GetFeatureReclaimLeft( int feature )
   {
      return self->GetFeatureReclaimLeft( feature  );
   }

   int GetNumUnitDefs(  )
   {
      return self->GetNumUnitDefs(   );
   }

   double GetUnitDefRadius( int def )
   {
      return self->GetUnitDefRadius( def  );
   }

   double GetUnitDefHeight( int def )
   {
      return self->GetUnitDefHeight( def  );
   }

   void EraseGroup( int groupid )
   {
      self->EraseGroup( groupid  );
   }

   System::String * GetModName(  )
   {
      return new System::String( string( self->GetModName(   ) ).c_str() );
   }

   System::String * GetMapName(  )
   {
      return new System::String( string( self->GetMapName(   ) ).c_str() );
   }

   void SetFigureColor( int group, double red, double green, double blue, double alpha )
   {
      self->SetFigureColor( group, red, green, blue, alpha  );
   }

   void DeleteFigureGroup( int group )
   {
      self->DeleteFigureGroup( group  );
   }

   int GetCurrentFrame(  )
   {
      return self->GetCurrentFrame(   );
   }

   int GetMyTeam(  )
   {
      return self->GetMyTeam(   );
   }

   int GetMyAllyTeam(  )
   {
      return self->GetMyAllyTeam(   );
   }

   int GetPlayerTeam( int player )
   {
      return self->GetPlayerTeam( player  );
   }

   bool AddUnitToGroup( int unitid, int groupid )
   {
      return self->AddUnitToGroup( unitid, groupid  );
   }

   bool RemoveUnitFromGroup( int unitid )
   {
      return self->RemoveUnitFromGroup( unitid  );
   }

   int GetUnitGroup( int unitid )
   {
      return self->GetUnitGroup( unitid  );
   }

   int GetUnitAiHint( int unitid )
   {
      return self->GetUnitAiHint( unitid  );
   }

   int GetUnitTeam( int unitid )
   {
      return self->GetUnitTeam( unitid  );
   }

   int GetUnitAllyTeam( int unitid )
   {
      return self->GetUnitAllyTeam( unitid  );
   }

   double GetUnitHealth( int unitid )
   {
      return self->GetUnitHealth( unitid  );
   }

   double GetUnitMaxHealth( int unitid )
   {
      return self->GetUnitMaxHealth( unitid  );
   }

   double GetUnitSpeed( int unitid )
   {
      return self->GetUnitSpeed( unitid  );
   }

   double GetUnitPower( int unitid )
   {
      return self->GetUnitPower( unitid  );
   }

   double GetUnitExperience( int unitid )
   {
      return self->GetUnitExperience( unitid  );
   }

   double GetUnitMaxRange( int unitid )
   {
      return self->GetUnitMaxRange( unitid  );
   }

   bool IsUnitActivated( int unitid )
   {
      return self->IsUnitActivated( unitid  );
   }

   bool UnitBeingBuilt( int unitid )
   {
      return self->UnitBeingBuilt( unitid  );
   }

   int GetBuildingFacing( int unitid )
   {
      return self->GetBuildingFacing( unitid  );
   }

   bool IsUnitCloaked( int unitid )
   {
      return self->IsUnitCloaked( unitid  );
   }

   bool IsUnitParalyzed( int unitid )
   {
      return self->IsUnitParalyzed( unitid  );
   }

   int GetMapWidth(  )
   {
      return self->GetMapWidth(   );
   }

   int GetMapHeight(  )
   {
      return self->GetMapHeight(   );
   }

   double GetMaxMetal(  )
   {
      return self->GetMaxMetal(   );
   }

   double GetExtractorRadius(  )
   {
      return self->GetExtractorRadius(   );
   }

   double GetMinWind(  )
   {
      return self->GetMinWind(   );
   }

   double GetMaxWind(  )
   {
      return self->GetMaxWind(   );
   }

   double GetTidalStrength(  )
   {
      return self->GetTidalStrength(   );
   }

   double GetGravity(  )
   {
      return self->GetGravity(   );
   }

   double GetElevation( double x, double z )
   {
      return self->GetElevation( x, z  );
   }

   double GetMetal(  )
   {
      return self->GetMetal(   );
   }

   double GetMetalIncome(  )
   {
      return self->GetMetalIncome(   );
   }

   double GetMetalUsage(  )
   {
      return self->GetMetalUsage(   );
   }

   double GetMetalStorage(  )
   {
      return self->GetMetalStorage(   );
   }

   double GetEnergy(  )
   {
      return self->GetEnergy(   );
   }

   double GetEnergyIncome(  )
   {
      return self->GetEnergyIncome(   );
   }
