/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine {
import engine.model.signals.DieWallAppearedSignal
import engine.model.signals.FrameEnteredSignal
import engine.model.signals.MissionAccomplishedSignal
import engine.model.signals.MissionFailedSignal
import engine.model.signals.WeaponUsedSignal
import engine.model.signals.bombs.BombSetSignal
import engine.model.signals.bombs.BombsExplodedSignal
import engine.model.signals.bombs.TriedToSetBombSignal
import engine.model.signals.bonuses.ObjectAppearedSignal
import engine.model.signals.bonuses.ObjectTakenSignal
import engine.model.signals.bonuses.TriedToTakeObjectSignal
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
import engine.model.signals.weapons.TriedToUseWeaponSignal

public class EngineContext {

    private static var _instance:EngineContext;

    //signals
    //---movement
    private var _playerCoordinatesChanged:PlayerCoordsChangedSignal = new PlayerCoordsChangedSignal();
    private var _playerViewDirectionChanged:PlayerViewDirectionChangedSignal = new PlayerViewDirectionChangedSignal();
    private var _playerInputDirectionChanged:PlayerInputDirectionChangedSignal = new PlayerInputDirectionChangedSignal();
    private var _enemyInputDirectionChanged:EnemyInputDirectionChangedSignal = new EnemyInputDirectionChangedSignal();
    private var _enemySmoothMovePerformed:EnemySmoothMovePerformedSignal = new EnemySmoothMovePerformedSignal();
    //---bombs
    private var _bombSet:BombSetSignal = new BombSetSignal();
    private var _bombExploded:BombsExplodedSignal = new BombsExplodedSignal();
    private var _triedToSetBomb:TriedToSetBombSignal = new TriedToSetBombSignal();
    //---weapons
    private var _triedToUseWeapon:TriedToUseWeaponSignal = new TriedToUseWeaponSignal();
    private var _weaponUsed:WeaponUsedSignal = new WeaponUsedSignal();
    //---explosions
    private var _explosionsChanged:ExplosionsChangedSignal = new ExplosionsChangedSignal();
    private var _explosionsAdded:ExplosionsAddedSignal = new ExplosionsAddedSignal();
    private var _explosionsUpdated:ExplosionsUpdatedSignal = new ExplosionsUpdatedSignal();
    private var _explosionsRemoved:ExplosionsRemovedSignal = new ExplosionsRemovedSignal();
    //---bonuses
    private var _objectAppeared:ObjectAppearedSignal = new ObjectAppearedSignal();
    private var _triedToTakeObject:TriedToTakeObjectSignal = new TriedToTakeObjectSignal();
    private var _objectTaken:ObjectTakenSignal = new ObjectTakenSignal();
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

    public static function get bombSet():BombSetSignal {
        return instance._bombSet;
    }

    public static function get bombExploded():BombsExplodedSignal {
        return instance._bombExploded;
    }

    public static function get triedToSetBomb():TriedToSetBombSignal {
        return instance._triedToSetBomb;
    }

    public static function get triedToUseWeapon():TriedToUseWeaponSignal {
        return instance._triedToUseWeapon;
    }

    public static function get weaponUsed():WeaponUsedSignal {
        return instance._weaponUsed;
    }

    public static function get explosionsChanged():ExplosionsChangedSignal {
        return instance._explosionsChanged;
    }

    public static function get explosionsAdded():ExplosionsAddedSignal {
        return instance._explosionsAdded;
    }

    public static function get explosionsUpdated():ExplosionsUpdatedSignal {
        return instance._explosionsUpdated;
    }

    public static function get explosionsRemoved():ExplosionsRemovedSignal {
        return instance._explosionsRemoved;
    }

    public static function get objectAppeared():ObjectAppearedSignal {
        return instance._objectAppeared;
    }

    public static function get triedToTakeObject():TriedToTakeObjectSignal {
        return instance._triedToTakeObject;
    }

    public static function get objectTaken():ObjectTakenSignal {
        return instance._objectTaken;
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
        //---bombs
        bombSet.removeAll()
        bombExploded.removeAll()
        triedToSetBomb.removeAll()
        //---weapons
        triedToUseWeapon.removeAll()
        weaponUsed.removeAll()
        //---explosions
        explosionsChanged.removeAll()
        explosionsAdded.removeAll()
        explosionsUpdated.removeAll()
        explosionsRemoved.removeAll()
        //---bonuses
        objectAppeared.removeAll()
        triedToTakeObject.removeAll()
        objectTaken.removeAll()
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
}
}
