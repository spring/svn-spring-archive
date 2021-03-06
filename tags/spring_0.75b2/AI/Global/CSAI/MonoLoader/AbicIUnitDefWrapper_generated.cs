// *** This is a generated file; if you want to change it, please change CSAIInterfaces.dll, which is the reference
// 
// This file was generated by MonoAbicWrappersGenerator, by Hugh Perkins hughperkins@gmail.com http://manageddreams.com
// 

using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Text;
using System.IO;

namespace CSharpAI
{
    public class UnitDef : MarshalByRefObject, IUnitDef
    {
        public IntPtr self = IntPtr.Zero;
        public UnitDef( IntPtr self )
        {
           this.self = self;
        }
      public System.Int32 GetNumBuildOptions( )

      {
         return ABICInterface.UnitDef_GetNumBuildOptions( self );
      }

      public System.String GetBuildOption(System.Int32 index )

      {
         return ABICInterface.UnitDef_GetBuildOption( self, index );
      }

      public System.String name
      {
          get{ return ABICInterface.UnitDef_get_name( self ); }
      }

      public System.String humanName
      {
          get{ return ABICInterface.UnitDef_get_humanName( self ); }
      }

      public System.String filename
      {
          get{ return ABICInterface.UnitDef_get_filename( self ); }
      }

      public System.Boolean loaded
      {
          get{ return ABICInterface.UnitDef_get_loaded( self ); }
      }

      public System.Int32 id
      {
          get{ return ABICInterface.UnitDef_get_id( self ); }
      }

      public System.String buildpicname
      {
          get{ return ABICInterface.UnitDef_get_buildpicname( self ); }
      }

      public System.Int32 aihint
      {
          get{ return ABICInterface.UnitDef_get_aihint( self ); }
      }

      public System.Int32 techLevel
      {
          get{ return ABICInterface.UnitDef_get_techLevel( self ); }
      }

      public System.Double metalUpkeep
      {
          get{ return ABICInterface.UnitDef_get_metalUpkeep( self ); }
      }

      public System.Double energyUpkeep
      {
          get{ return ABICInterface.UnitDef_get_energyUpkeep( self ); }
      }

      public System.Double metalMake
      {
          get{ return ABICInterface.UnitDef_get_metalMake( self ); }
      }

      public System.Double makesMetal
      {
          get{ return ABICInterface.UnitDef_get_makesMetal( self ); }
      }

      public System.Double energyMake
      {
          get{ return ABICInterface.UnitDef_get_energyMake( self ); }
      }

      public System.Double metalCost
      {
          get{ return ABICInterface.UnitDef_get_metalCost( self ); }
      }

      public System.Double energyCost
      {
          get{ return ABICInterface.UnitDef_get_energyCost( self ); }
      }

      public System.Double buildTime
      {
          get{ return ABICInterface.UnitDef_get_buildTime( self ); }
      }

      public System.Double extractsMetal
      {
          get{ return ABICInterface.UnitDef_get_extractsMetal( self ); }
      }

      public System.Double extractRange
      {
          get{ return ABICInterface.UnitDef_get_extractRange( self ); }
      }

      public System.Double windGenerator
      {
          get{ return ABICInterface.UnitDef_get_windGenerator( self ); }
      }

      public System.Double tidalGenerator
      {
          get{ return ABICInterface.UnitDef_get_tidalGenerator( self ); }
      }

      public System.Double metalStorage
      {
          get{ return ABICInterface.UnitDef_get_metalStorage( self ); }
      }

      public System.Double energyStorage
      {
          get{ return ABICInterface.UnitDef_get_energyStorage( self ); }
      }

      public System.Double autoHeal
      {
          get{ return ABICInterface.UnitDef_get_autoHeal( self ); }
      }

      public System.Double idleAutoHeal
      {
          get{ return ABICInterface.UnitDef_get_idleAutoHeal( self ); }
      }

      public System.Int32 idleTime
      {
          get{ return ABICInterface.UnitDef_get_idleTime( self ); }
      }

      public System.Double power
      {
          get{ return ABICInterface.UnitDef_get_power( self ); }
      }

      public System.Double health
      {
          get{ return ABICInterface.UnitDef_get_health( self ); }
      }

      public System.Double speed
      {
          get{ return ABICInterface.UnitDef_get_speed( self ); }
      }

      public System.Double turnRate
      {
          get{ return ABICInterface.UnitDef_get_turnRate( self ); }
      }

      public System.Int32 moveType
      {
          get{ return ABICInterface.UnitDef_get_moveType( self ); }
      }

      public System.Boolean upright
      {
          get{ return ABICInterface.UnitDef_get_upright( self ); }
      }

      public System.Double controlRadius
      {
          get{ return ABICInterface.UnitDef_get_controlRadius( self ); }
      }

      public System.Double losRadius
      {
          get{ return ABICInterface.UnitDef_get_losRadius( self ); }
      }

      public System.Double airLosRadius
      {
          get{ return ABICInterface.UnitDef_get_airLosRadius( self ); }
      }

      public System.Double losHeight
      {
          get{ return ABICInterface.UnitDef_get_losHeight( self ); }
      }

      public System.Int32 radarRadius
      {
          get{ return ABICInterface.UnitDef_get_radarRadius( self ); }
      }

      public System.Int32 sonarRadius
      {
          get{ return ABICInterface.UnitDef_get_sonarRadius( self ); }
      }

      public System.Int32 jammerRadius
      {
          get{ return ABICInterface.UnitDef_get_jammerRadius( self ); }
      }

      public System.Int32 sonarJamRadius
      {
          get{ return ABICInterface.UnitDef_get_sonarJamRadius( self ); }
      }

      public System.Int32 seismicRadius
      {
          get{ return ABICInterface.UnitDef_get_seismicRadius( self ); }
      }

      public System.Double seismicSignature
      {
          get{ return ABICInterface.UnitDef_get_seismicSignature( self ); }
      }

      public System.Boolean stealth
      {
          get{ return ABICInterface.UnitDef_get_stealth( self ); }
      }

      public System.Double buildSpeed
      {
          get{ return ABICInterface.UnitDef_get_buildSpeed( self ); }
      }

      public System.Double buildDistance
      {
          get{ return ABICInterface.UnitDef_get_buildDistance( self ); }
      }

      public System.Double mass
      {
          get{ return ABICInterface.UnitDef_get_mass( self ); }
      }

      public System.Double maxSlope
      {
          get{ return ABICInterface.UnitDef_get_maxSlope( self ); }
      }

      public System.Double maxHeightDif
      {
          get{ return ABICInterface.UnitDef_get_maxHeightDif( self ); }
      }

      public System.Double minWaterDepth
      {
          get{ return ABICInterface.UnitDef_get_minWaterDepth( self ); }
      }

      public System.Double waterline
      {
          get{ return ABICInterface.UnitDef_get_waterline( self ); }
      }

      public System.Double maxWaterDepth
      {
          get{ return ABICInterface.UnitDef_get_maxWaterDepth( self ); }
      }

      public System.Double armoredMultiple
      {
          get{ return ABICInterface.UnitDef_get_armoredMultiple( self ); }
      }

      public System.Int32 armorType
      {
          get{ return ABICInterface.UnitDef_get_armorType( self ); }
      }

      public System.String type
      {
          get{ return ABICInterface.UnitDef_get_type( self ); }
      }

      public System.String tooltip
      {
          get{ return ABICInterface.UnitDef_get_tooltip( self ); }
      }

      public System.String wreckName
      {
          get{ return ABICInterface.UnitDef_get_wreckName( self ); }
      }

      public System.String deathExplosion
      {
          get{ return ABICInterface.UnitDef_get_deathExplosion( self ); }
      }

      public System.String selfDExplosion
      {
          get{ return ABICInterface.UnitDef_get_selfDExplosion( self ); }
      }

      public System.String TEDClassString
      {
          get{ return ABICInterface.UnitDef_get_TEDClassString( self ); }
      }

      public System.String categoryString
      {
          get{ return ABICInterface.UnitDef_get_categoryString( self ); }
      }

      public System.String iconType
      {
          get{ return ABICInterface.UnitDef_get_iconType( self ); }
      }

      public System.Int32 selfDCountdown
      {
          get{ return ABICInterface.UnitDef_get_selfDCountdown( self ); }
      }

      public System.Boolean canfly
      {
          get{ return ABICInterface.UnitDef_get_canfly( self ); }
      }

      public System.Boolean canmove
      {
          get{ return ABICInterface.UnitDef_get_canmove( self ); }
      }

      public System.Boolean canhover
      {
          get{ return ABICInterface.UnitDef_get_canhover( self ); }
      }

      public System.Boolean floater
      {
          get{ return ABICInterface.UnitDef_get_floater( self ); }
      }

      public System.Boolean builder
      {
          get{ return ABICInterface.UnitDef_get_builder( self ); }
      }

      public System.Boolean activateWhenBuilt
      {
          get{ return ABICInterface.UnitDef_get_activateWhenBuilt( self ); }
      }

      public System.Boolean onoffable
      {
          get{ return ABICInterface.UnitDef_get_onoffable( self ); }
      }

      public System.Boolean reclaimable
      {
          get{ return ABICInterface.UnitDef_get_reclaimable( self ); }
      }

      public System.Boolean canRestore
      {
          get{ return ABICInterface.UnitDef_get_canRestore( self ); }
      }

      public System.Boolean canRepair
      {
          get{ return ABICInterface.UnitDef_get_canRepair( self ); }
      }

      public System.Boolean canReclaim
      {
          get{ return ABICInterface.UnitDef_get_canReclaim( self ); }
      }

      public System.Boolean noAutoFire
      {
          get{ return ABICInterface.UnitDef_get_noAutoFire( self ); }
      }

      public System.Boolean canAttack
      {
          get{ return ABICInterface.UnitDef_get_canAttack( self ); }
      }

      public System.Boolean canPatrol
      {
          get{ return ABICInterface.UnitDef_get_canPatrol( self ); }
      }

      public System.Boolean canFight
      {
          get{ return ABICInterface.UnitDef_get_canFight( self ); }
      }

      public System.Boolean canGuard
      {
          get{ return ABICInterface.UnitDef_get_canGuard( self ); }
      }

      public System.Boolean canBuild
      {
          get{ return ABICInterface.UnitDef_get_canBuild( self ); }
      }

      public System.Boolean canAssist
      {
          get{ return ABICInterface.UnitDef_get_canAssist( self ); }
      }

      public System.Boolean canRepeat
      {
          get{ return ABICInterface.UnitDef_get_canRepeat( self ); }
      }

      public System.Double wingDrag
      {
          get{ return ABICInterface.UnitDef_get_wingDrag( self ); }
      }

      public System.Double wingAngle
      {
          get{ return ABICInterface.UnitDef_get_wingAngle( self ); }
      }

      public System.Double drag
      {
          get{ return ABICInterface.UnitDef_get_drag( self ); }
      }

      public System.Double frontToSpeed
      {
          get{ return ABICInterface.UnitDef_get_frontToSpeed( self ); }
      }

      public System.Double speedToFront
      {
          get{ return ABICInterface.UnitDef_get_speedToFront( self ); }
      }

      public System.Double myGravity
      {
          get{ return ABICInterface.UnitDef_get_myGravity( self ); }
      }

      public System.Double maxBank
      {
          get{ return ABICInterface.UnitDef_get_maxBank( self ); }
      }

      public System.Double maxPitch
      {
          get{ return ABICInterface.UnitDef_get_maxPitch( self ); }
      }

      public System.Double turnRadius
      {
          get{ return ABICInterface.UnitDef_get_turnRadius( self ); }
      }

      public System.Double wantedHeight
      {
          get{ return ABICInterface.UnitDef_get_wantedHeight( self ); }
      }

      public System.Boolean hoverAttack
      {
          get{ return ABICInterface.UnitDef_get_hoverAttack( self ); }
      }

      public System.Double dlHoverFactor
      {
          get{ return ABICInterface.UnitDef_get_dlHoverFactor( self ); }
      }

      public System.Double maxAcc
      {
          get{ return ABICInterface.UnitDef_get_maxAcc( self ); }
      }

      public System.Double maxDec
      {
          get{ return ABICInterface.UnitDef_get_maxDec( self ); }
      }

      public System.Double maxAileron
      {
          get{ return ABICInterface.UnitDef_get_maxAileron( self ); }
      }

      public System.Double maxElevator
      {
          get{ return ABICInterface.UnitDef_get_maxElevator( self ); }
      }

      public System.Double maxRudder
      {
          get{ return ABICInterface.UnitDef_get_maxRudder( self ); }
      }

      public System.Int32 xsize
      {
          get{ return ABICInterface.UnitDef_get_xsize( self ); }
      }

      public System.Int32 ysize
      {
          get{ return ABICInterface.UnitDef_get_ysize( self ); }
      }

      public System.Int32 buildangle
      {
          get{ return ABICInterface.UnitDef_get_buildangle( self ); }
      }

      public System.Double loadingRadius
      {
          get{ return ABICInterface.UnitDef_get_loadingRadius( self ); }
      }

      public System.Int32 transportCapacity
      {
          get{ return ABICInterface.UnitDef_get_transportCapacity( self ); }
      }

      public System.Int32 transportSize
      {
          get{ return ABICInterface.UnitDef_get_transportSize( self ); }
      }

      public System.Boolean isAirBase
      {
          get{ return ABICInterface.UnitDef_get_isAirBase( self ); }
      }

      public System.Double transportMass
      {
          get{ return ABICInterface.UnitDef_get_transportMass( self ); }
      }

      public System.Boolean canCloak
      {
          get{ return ABICInterface.UnitDef_get_canCloak( self ); }
      }

      public System.Boolean startCloaked
      {
          get{ return ABICInterface.UnitDef_get_startCloaked( self ); }
      }

      public System.Double cloakCost
      {
          get{ return ABICInterface.UnitDef_get_cloakCost( self ); }
      }

      public System.Double cloakCostMoving
      {
          get{ return ABICInterface.UnitDef_get_cloakCostMoving( self ); }
      }

      public System.Double decloakDistance
      {
          get{ return ABICInterface.UnitDef_get_decloakDistance( self ); }
      }

      public System.Boolean canKamikaze
      {
          get{ return ABICInterface.UnitDef_get_canKamikaze( self ); }
      }

      public System.Double kamikazeDist
      {
          get{ return ABICInterface.UnitDef_get_kamikazeDist( self ); }
      }

      public System.Boolean targfac
      {
          get{ return ABICInterface.UnitDef_get_targfac( self ); }
      }

      public System.Boolean canDGun
      {
          get{ return ABICInterface.UnitDef_get_canDGun( self ); }
      }

      public System.Boolean needGeo
      {
          get{ return ABICInterface.UnitDef_get_needGeo( self ); }
      }

      public System.Boolean isFeature
      {
          get{ return ABICInterface.UnitDef_get_isFeature( self ); }
      }

      public System.Boolean hideDamage
      {
          get{ return ABICInterface.UnitDef_get_hideDamage( self ); }
      }

      public System.Boolean isCommander
      {
          get{ return ABICInterface.UnitDef_get_isCommander( self ); }
      }

      public System.Boolean showPlayerName
      {
          get{ return ABICInterface.UnitDef_get_showPlayerName( self ); }
      }

      public System.Boolean canResurrect
      {
          get{ return ABICInterface.UnitDef_get_canResurrect( self ); }
      }

      public System.Boolean canCapture
      {
          get{ return ABICInterface.UnitDef_get_canCapture( self ); }
      }

      public System.Int32 highTrajectoryType
      {
          get{ return ABICInterface.UnitDef_get_highTrajectoryType( self ); }
      }

      public System.Boolean leaveTracks
      {
          get{ return ABICInterface.UnitDef_get_leaveTracks( self ); }
      }

      public System.Double trackWidth
      {
          get{ return ABICInterface.UnitDef_get_trackWidth( self ); }
      }

      public System.Double trackOffset
      {
          get{ return ABICInterface.UnitDef_get_trackOffset( self ); }
      }

      public System.Double trackStrength
      {
          get{ return ABICInterface.UnitDef_get_trackStrength( self ); }
      }

      public System.Double trackStretch
      {
          get{ return ABICInterface.UnitDef_get_trackStretch( self ); }
      }

      public System.Int32 trackType
      {
          get{ return ABICInterface.UnitDef_get_trackType( self ); }
      }

      public System.Boolean canDropFlare
      {
          get{ return ABICInterface.UnitDef_get_canDropFlare( self ); }
      }

      public System.Double flareReloadTime
      {
          get{ return ABICInterface.UnitDef_get_flareReloadTime( self ); }
      }

      public System.Double flareEfficieny
      {
          get{ return ABICInterface.UnitDef_get_flareEfficieny( self ); }
      }

      public System.Double flareDelay
      {
          get{ return ABICInterface.UnitDef_get_flareDelay( self ); }
      }

      public System.Int32 flareTime
      {
          get{ return ABICInterface.UnitDef_get_flareTime( self ); }
      }

      public System.Int32 flareSalvoSize
      {
          get{ return ABICInterface.UnitDef_get_flareSalvoSize( self ); }
      }

      public System.Int32 flareSalvoDelay
      {
          get{ return ABICInterface.UnitDef_get_flareSalvoDelay( self ); }
      }

      public System.Boolean smoothAnim
      {
          get{ return ABICInterface.UnitDef_get_smoothAnim( self ); }
      }

      public System.Boolean isMetalMaker
      {
          get{ return ABICInterface.UnitDef_get_isMetalMaker( self ); }
      }

      public System.Boolean canLoopbackAttack
      {
          get{ return ABICInterface.UnitDef_get_canLoopbackAttack( self ); }
      }

      public System.Boolean levelGround
      {
          get{ return ABICInterface.UnitDef_get_levelGround( self ); }
      }

      public System.Boolean useBuildingGroundDecal
      {
          get{ return ABICInterface.UnitDef_get_useBuildingGroundDecal( self ); }
      }

      public System.Int32 buildingDecalType
      {
          get{ return ABICInterface.UnitDef_get_buildingDecalType( self ); }
      }

      public System.Int32 buildingDecalSizeX
      {
          get{ return ABICInterface.UnitDef_get_buildingDecalSizeX( self ); }
      }

      public System.Int32 buildingDecalSizeY
      {
          get{ return ABICInterface.UnitDef_get_buildingDecalSizeY( self ); }
      }

      public System.Double buildingDecalDecaySpeed
      {
          get{ return ABICInterface.UnitDef_get_buildingDecalDecaySpeed( self ); }
      }

      public System.Boolean isfireplatform
      {
          get{ return ABICInterface.UnitDef_get_isfireplatform( self ); }
      }

      public System.Boolean showNanoFrame
      {
          get{ return ABICInterface.UnitDef_get_showNanoFrame( self ); }
      }

      public System.Boolean showNanoSpray
      {
          get{ return ABICInterface.UnitDef_get_showNanoSpray( self ); }
      }

      public System.Double maxFuel
      {
          get{ return ABICInterface.UnitDef_get_maxFuel( self ); }
      }

      public System.Double refuelTime
      {
          get{ return ABICInterface.UnitDef_get_refuelTime( self ); }
      }

      public System.Double minAirBasePower
      {
          get{ return ABICInterface.UnitDef_get_minAirBasePower( self ); }
      }

#line 0 "AbicIUnitDefWrapper_manualtweaks.txt"



public IMoveData movedata
{
   get
   {
      IntPtr movedataptr = ABICInterface.UnitDef_get_movedata( self );
      if( movedataptr == IntPtr.Zero )
      {
         return null;
       }
        return new MoveData( movedataptr );
   }
}

    }
}
