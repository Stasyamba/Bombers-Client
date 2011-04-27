/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine {
import engine.games.quest.monsters.Monster
import engine.games.quest.monsters.MonsterType
import engine.model.signals.DieWallAppearedSignal
import engine.model.signals.FrameEnteredSignal
import engine.model.signals.MissionAccomplishedSignal
import engine.model.signals.MissionFailedSignal
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
    private var _enemyDirectionForecast:Signal = new Signal(int,Direction)
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
    //---goals
    private var _taskAccomplished:MissionAccomplishedSignal = new MissionAccomplishedSignal();
    private var _taskFailed:MissionFailedSignal = new MissionFailedSignal();

    //---frame
    private var _frameEntered:FrameEnteredSignal = new FrameEnteredSignal();
    private var _smokeAdded:SmokeAddedSignal = new SmokeAddedSignal()

    //---quests only
    private var _monsterDirectionChanged:MonsterDirectionChangedSignal = new MonsterDirectionChangedSignal()
    private var _monsterCoordsChanged:MonsterCoordsChangedSignal = new MonsterCoordsChangedSignal()
    private var _needToAddMonster:Signal = new Signal(MonsterType, Number, Number)
    private var _monsterAdded:Signal = new Signal(Monster)
    private var _monsterDied:Signal = new Signal(Monster)


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

    public static function get taskAccomplished():MissionAccomplishedSignal {
        return instance._taskAccomplished;
    }

    public static function get taskFailed():MissionFailedSignal {
        return instance._taskFailed;
    }

    public static function get frameEntered():FrameEnteredSignal {
        return instance._frameEntered;
    }

    public static function clear():void {
        //---movement
        playerCoordinatesChanged.removeAll()
        playerViewDirectionChanged.removeAll()
        playerInputDirectionChanged.removeAll()
        enemyInputDirectionChanged.removeAll()
        enemySmoothMovePerformed.removeAll()
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
        //---goals
        taskAccomplished.removeAll()
        taskFailed.removeAll()
    }

    public static function get moveTick():MoveTickSignal {
        return instance._moveTick
    }

    public static function get monsterDirectionChanged():MonsterDirectionChangedSignal {
        return instance._monsterDirectionChanged
    }

    public static function get monsterCoordsChanged():MonsterCoordsChangedSignal {
        return instance._monsterCoordsChanged
    }

    public static function get monsterDied():Signal {
        return instance._monsterDied
    }

    public static function get needToAddMonster():Signal {
        return instance._needToAddMonster
    }

    public static function get monsterAdded():Signal {
        return instance._monsterAdded
    }

    public static function get enemyDirectionForecast():Signal {
        return instance._enemyDirectionForecast
    }
}
}
