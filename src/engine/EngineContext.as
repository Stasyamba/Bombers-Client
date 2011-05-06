/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine {
import engine.games.quest.monsters.Monster
import engine.games.quest.monsters.MonsterType
import engine.games.quest.monsters.walking.IWalkingStrategy
import engine.model.signals.DieWallAppearedSignal
import engine.model.signals.FrameEnteredSignal
import engine.model.signals.MonsterCoordsChangedSignal
import engine.model.signals.MonsterDirectionChangedSignal
import engine.model.signals.MoveTickSignal
import engine.model.signals.SmokeAddedSignal
import engine.model.signals.WeaponActivatedSignal
import engine.model.signals.WeaponDeactivatedSignal
import engine.model.signals.WeaponUnitSpentSignal
import engine.model.signals.bonuses.ObjectActivatedSignal
import engine.model.signals.bonuses.ObjectAddedSignal
import engine.model.signals.bonuses.TriedToActivateObjectSignal
import engine.model.signals.damage.EnemyDamagedSignal
import engine.model.signals.damage.EnemyDiedSignal
import engine.model.signals.damage.PlayerDamagedSignal
import engine.model.signals.damage.PlayerDiedSignal
import engine.model.signals.explosions.ExplosionsAddedSignal
import engine.model.signals.explosions.ExplosionsChangedSignal
import engine.model.signals.explosions.ExplosionsRemovedSignal
import engine.model.signals.explosions.ExplosionsUpdatedSignal
import engine.model.signals.movement.EnemyInputDirectionChangedSignal
import engine.model.signals.movement.EnemySmoothMovePerformedSignal
import engine.model.signals.movement.PlayerCoordsChangedSignal
import engine.model.signals.movement.PlayerInputDirectionChangedSignal
import engine.model.signals.movement.PlayerViewDirectionChangedSignal
import engine.model.signals.weapons.TriedToActivateWeaponSignal
import engine.utils.Direction

import flash.geom.Point

import org.osflash.signals.Signal

public class EngineContext {

    private static var _instance:EngineContext;

    //signals
    //---movement
    private var _moveTick:MoveTickSignal = new MoveTickSignal()
    private var _playerCoordinatesChanged:PlayerCoordsChangedSignal = new PlayerCoordsChangedSignal();
    private var _playerViewDirectionChanged:PlayerViewDirectionChangedSignal = new PlayerViewDirectionChangedSignal();
    private var _playerInputDirectionChanged:PlayerInputDirectionChangedSignal = new PlayerInputDirectionChangedSignal();
    private var _enemyInputDirectionChanged:EnemyInputDirectionChangedSignal = new EnemyInputDirectionChangedSignal();
    private var _enemyDirectionForecast:Signal = new Signal(int, Direction)
    private var _enemySmoothMovePerformed:EnemySmoothMovePerformedSignal = new EnemySmoothMovePerformedSignal();
    //---weapons
    private var _currentWeaponChanged:Signal = new Signal();
    private var _triedToActivateWeapon:TriedToActivateWeaponSignal = new TriedToActivateWeaponSignal();
    private var _weaponActivated:WeaponActivatedSignal = new WeaponActivatedSignal();
    private var _weaponDeactivated:WeaponDeactivatedSignal = new WeaponDeactivatedSignal();

    private var _weaponUnitSpent:WeaponUnitSpentSignal = new WeaponUnitSpentSignal()
    //---explosions
    private var _explosionsChanged:ExplosionsChangedSignal = new ExplosionsChangedSignal();
    private var _explosionGroupAdded:ExplosionsAddedSignal = new ExplosionsAddedSignal();
    private var _explosionsUpdated:ExplosionsUpdatedSignal = new ExplosionsUpdatedSignal();
    private var _explosionsRemoved:ExplosionsRemovedSignal = new ExplosionsRemovedSignal();
    //---dynObjects
    private var _objectAdded:ObjectAddedSignal = new ObjectAddedSignal();
    private var _triedToActivateObject:TriedToActivateObjectSignal = new TriedToActivateObjectSignal();
    private var _objectActivated:ObjectActivatedSignal = new ObjectActivatedSignal();
    //---damage
    private var _playerDamaged:PlayerDamagedSignal = new PlayerDamagedSignal();
    private var _enemyDamaged:EnemyDamagedSignal = new EnemyDamagedSignal();
    private var _playerDied:PlayerDiedSignal = new PlayerDiedSignal();
    private var _enemyDied:EnemyDiedSignal = new EnemyDiedSignal();
    private var _deathWallAppeared:DieWallAppearedSignal = new DieWallAppearedSignal();

    //---frame
    private var _frameEntered:FrameEnteredSignal = new FrameEnteredSignal();
    private var _smokeAdded:SmokeAddedSignal = new SmokeAddedSignal()

    //---quests only
    private var _qMonsterDirectionChanged:MonsterDirectionChangedSignal = new MonsterDirectionChangedSignal()
    private var _qMonsterCoordsChanged:MonsterCoordsChangedSignal = new MonsterCoordsChangedSignal()
    private var _qNeedToAddMonster:Signal = new Signal(MonsterType, int, int, IWalkingStrategy)
    private var _qMonsterAdded:Signal = new Signal(Monster)
    private var _qMonsterDied:Signal = new Signal(Monster)
    private var _qActivateWeapon:WeaponActivatedSignal = new WeaponActivatedSignal()

    //---goals
    private var _qAddObject:ObjectAddedSignal = new ObjectAddedSignal()
    private var _qPlayerActivateObject:ObjectActivatedSignal = new ObjectActivatedSignal()
    private var _qMonsterActivateObject:ObjectActivatedSignal = new ObjectActivatedSignal()
    private var _qMonsterDamaged:Signal = new Signal(Monster, int)
    private var _qTimeOut:Signal = new Signal()

    public static var redBaloon:Signal = new Signal(Point,int);
    public static var greenBaloon:Signal = new Signal(Number, Number, Direction)
    public static var pingChanged:Signal = new Signal(Point)

    //Monster, damage


    function EngineContext() {
    }

    public static function get instance():EngineContext {
        if (!_instance)
            _instance = new EngineContext()
        return _instance;
    }


    public static function get playerCoordinatesChanged():PlayerCoordsChangedSignal {
        return instance._playerCoordinatesChanged;
    }

    public static function get playerViewDirectionChanged():PlayerViewDirectionChangedSignal {
        return instance._playerViewDirectionChanged;
    }

    public static function get playerInputDirectionChanged():PlayerInputDirectionChangedSignal {
        return instance._playerInputDirectionChanged;
    }

    public static function get enemyInputDirectionChanged():EnemyInputDirectionChangedSignal {
        return instance._enemyInputDirectionChanged;
    }

    public static function get enemySmoothMovePerformed():EnemySmoothMovePerformedSignal {
        return instance._enemySmoothMovePerformed;
    }

    public static function get currentWeaponChanged():Signal {
        return instance._currentWeaponChanged
    }

    public static function get triedToActivateWeapon():TriedToActivateWeaponSignal {
        return instance._triedToActivateWeapon;
    }

    public static function get weaponActivated():WeaponActivatedSignal {
        return instance._weaponActivated;
    }

    public static function get weaponDeactivated():WeaponDeactivatedSignal {
        return instance._weaponDeactivated;
    }

    public static function get weaponUnitSpent():WeaponUnitSpentSignal {
        return instance._weaponUnitSpent
    }

    public static function get explosionsChanged():ExplosionsChangedSignal {
        return instance._explosionsChanged;
    }

    public static function get explosionGroupAdded():ExplosionsAddedSignal {
        return instance._explosionGroupAdded;
    }

    public static function get explosionsUpdated():ExplosionsUpdatedSignal {
        return instance._explosionsUpdated;
    }

    public static function get explosionsRemoved():ExplosionsRemovedSignal {
        return instance._explosionsRemoved;
    }

    public static function get smokeAdded():SmokeAddedSignal {
        return _instance._smokeAdded
    }

    public static function get objectAdded():ObjectAddedSignal {
        return instance._objectAdded;
    }

    public static function get triedToActivateObject():TriedToActivateObjectSignal {
        return instance._triedToActivateObject;
    }

    public static function get objectActivated():ObjectActivatedSignal {
        return instance._objectActivated;
    }

    public static function get playerDamaged():PlayerDamagedSignal {
        return instance._playerDamaged;
    }

    public static function get enemyDamaged():EnemyDamagedSignal {
        return instance._enemyDamaged;
    }

    public static function get playerDied():PlayerDiedSignal {
        return instance._playerDied;
    }

    public static function get enemyDied():EnemyDiedSignal {
        return instance._enemyDied;
    }

    public static function get deathWallAppeared():DieWallAppearedSignal {
        return instance._deathWallAppeared;
    }

    public static function get moveTick():MoveTickSignal {
        return instance._moveTick
    }

    public static function get enemyDirectionForecast():Signal {
        return instance._enemyDirectionForecast
    }


    public static function get frameEntered():FrameEnteredSignal {
        return instance._frameEntered;
    }

    //quest
    public static function get qMonsterDirectionChanged():MonsterDirectionChangedSignal {
        return instance._qMonsterDirectionChanged
    }

    public static function get qMonsterCoordsChanged():MonsterCoordsChangedSignal {
        return instance._qMonsterCoordsChanged
    }

    public static function get qMonsterDied():Signal {
        return instance._qMonsterDied
    }

    public static function get qNeedToAddMonster():Signal {
        return instance._qNeedToAddMonster
    }

    public static function get qMonsterAdded():Signal {
        return instance._qMonsterAdded
    }

    public static function get qActivateWeapon():WeaponActivatedSignal {
        return instance._qActivateWeapon
    }

    public static function get qAddObject():ObjectAddedSignal {
        return instance._qAddObject
    }

    public static function get qPlayerActivateObject():ObjectActivatedSignal {
        return instance._qPlayerActivateObject
    }

    public static function get qMonsterActivateObject():ObjectActivatedSignal {
        return instance._qMonsterActivateObject
    }

    public static function get qMonsterDamaged():Signal {
        return instance._qMonsterDamaged
    }

    public static function get qTimeOut():Signal {
        return instance._qTimeOut
    }

    //clear
    public static function clear():void {
        redBaloon.removeAll()
        greenBaloon.removeAll()

        //---movement
        playerCoordinatesChanged.removeAll()
        playerViewDirectionChanged.removeAll()
        playerInputDirectionChanged.removeAll()
        enemyInputDirectionChanged.removeAll()
        enemySmoothMovePerformed.removeAll()

        moveTick.removeAll()
        enemyDirectionForecast.removeAll()
        //---weapons
        triedToActivateWeapon.removeAll()
        weaponActivated.removeAll()
        currentWeaponChanged.removeAll()
        weaponDeactivated.removeAll()

        weaponUnitSpent.removeAll()
        //---explosions
        explosionsChanged.removeAll()
        explosionGroupAdded.removeAll()
        explosionsUpdated.removeAll()
        explosionsRemoved.removeAll()
        smokeAdded.removeAll()
        //---dynObjects
        objectAdded.removeAll()
        triedToActivateObject.removeAll()
        objectActivated.removeAll()
        //---damage
        playerDamaged.removeAll()
        enemyDamaged.removeAll()
        playerDied.removeAll()
        enemyDied.removeAll()
        deathWallAppeared.removeAll()

        //---quests
        qActivateWeapon.removeAll()
        qAddObject.removeAll()
        qMonsterActivateObject.removeAll()
        qMonsterAdded.removeAll()
        qMonsterCoordsChanged.removeAll()
        qMonsterDamaged.removeAll()
        qMonsterDied.removeAll()
        qMonsterDirectionChanged.removeAll()
        qNeedToAddMonster.removeAll()
        qPlayerActivateObject.removeAll()
        qTimeOut.removeAll()
    }
}
}
