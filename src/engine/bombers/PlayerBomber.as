/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.items.ItemType

import engine.EngineContext
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombers.skin.BomberSkin
import engine.bombss.BombType
import engine.bombss.BombsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.utils.Direction
import engine.weapons.NullWeapon
import engine.weapons.WeaponBuilder
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon
import engine.weapons.interfaces.IWeapon

public class PlayerBomber extends BomberBase implements IPlayerBomber {

    private var _direction:InputDirection;

    private var lastViewDir:Direction = Direction.NONE;

    private var _gameProfile:GameProfile
    /*
     * use BombersBuilder instead
     * */
    protected var _weaponBuilder:WeaponBuilder;
    protected var _currentWeapon:IWeapon

    public function PlayerBomber(game:IGame, playerId:int, gameProfile:GameProfile, color:PlayerColor, direction:InputDirection, weaponBuilder:WeaponBuilder, bombBuilder:BombsBuilder) {
        super(game, playerId, gameProfile.currentBomberType, gameProfile.nick, color, BomberSkin.fromBomberType(gameProfile.currentBomberType), bombBuilder);
        _weaponBuilder = weaponBuilder
        this._gameProfile = gameProfile
        if(gameProfile.selectedWeaponLeftHand != null)
            _currentWeapon = weaponBuilder.fromItemType(gameProfile.selectedWeaponLeftHand.itemType,gameProfile.selectedWeaponLeftHand.itemCount)
        _direction = direction;

        EngineContext.currentWeaponChanged.add(onCurrentWeaponChanged)
    }

    private function onCurrentWeaponChanged():void {
        if(_gameProfile.selectedWeaponLeftHand != null)
            _currentWeapon = _weaponBuilder.fromItemType(_gameProfile.selectedWeaponLeftHand.itemType,_gameProfile.selectedWeaponLeftHand.itemCount)
        else
            _currentWeapon = NullWeapon.instance
    }

    public function performMotion(moveAmount:Number):void {
        if (_direction.direction == Direction.NONE)
            return;

        var x:int = _coords.getRealX();
        var y:int = _coords.getRealY();

        switch (_direction.direction) {
            case Direction.LEFT:
                _coords.stepLeft(moveAmount);
                checkViewHorDirectionChanged(x);
                break;
            case Direction.RIGHT:
                _coords.stepRight(moveAmount);
                checkViewHorDirectionChanged(x);
                break;
            case Direction.UP:
                _coords.stepUp(moveAmount);
                checkViewVertDirectionChanged(x);
                break;
            case Direction.DOWN:
                _coords.stepDown(moveAmount);
                checkViewVertDirectionChanged(x);
                break;
        }
        if (x != _coords.getRealX() || y != _coords.getRealY()) {
            EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());
        } else if (lastViewDir != Direction.NONE) {
            lastViewDir = Direction.NONE;
            EngineContext.playerViewDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), Direction.NONE);
        }
    }

    private function checkViewHorDirectionChanged(oldX:int):void {
        if (_coords.getRealX() != oldX && lastViewDir != _direction.direction) {
            lastViewDir = _direction.direction;
            EngineContext.playerViewDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _direction.direction);
        }
    }

    private function checkViewVertDirectionChanged(oldY:int):void {
        if (_coords.getRealY() != oldY && lastViewDir != _direction.direction) {
            lastViewDir = _direction.direction;
            EngineContext.playerViewDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _direction.direction);
        }
    }

    private function viewDirectionChanged():Boolean {
        return (Direction.isHorizontal(_direction.direction) && _coords.yDef == 0) ||
                (Direction.isVertical(_direction.direction) && _coords.xDef == 0) ||
                (_direction.direction == Direction.NONE && lastViewDir != Direction.NONE );
    }

    private function updateInputDirection():void {
        _gameSkin.updateSkin(_direction.direction);

        var flag:Boolean = viewDirectionChanged();
        if (flag)
            lastViewDir = _direction.direction;
        EngineContext.playerInputDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _direction.direction, flag);
    }


    private function startMotion():void {

    }

    private function endMotion():void {

    }

    public function addDirection(m:Direction):void {
        var dirBefore:Direction = _direction.direction;
        _direction.addDirection(m);

        if (_direction.hasAnyDirection())
            startMotion();

        if (dirBefore != _direction.direction) {
            updateInputDirection()
        }

    }

    public function removeDirection(m:Direction):void {
        var dirBefore:Direction = _direction.direction;
        _direction.removeDirection(m);
        if (!_direction.hasAnyDirection())
            endMotion();

        if (dirBefore != _direction.direction) {
            updateInputDirection();
        }
    }

    public override function move(elapsedTime:Number):void {
        performMotion(elapsedTime * speed)
    }

    public function setBomb(bombType:BombType):void {
        if (_map.getBlock(coords.elemX, coords.elemY).canSetBomb() && bombCount > 0 && !isDead) {
            EngineContext.triedToSetBomb.dispatch(coords.elemX, coords.elemY, bombType);
        }
    }

    public override function explode(expl:IExplosion):void {

        _life -= expl.damage;
        if (life < 0) life = 0;

        EngineContext.playerDamaged.dispatch(expl.damage, isDead)
        if (isDead) {
            EngineContext.playerDied.dispatch();
            return;
        }
        super.makeImmortalFor(immortalTime);
    }

    public override function kill():void {
        EngineContext.playerDied.dispatch();
        EngineContext.playerDamaged.dispatch(_life, true);
        _life = 0;
    }

    public function tryUseWeapon():void {
        if (isDead) return;
        if (currentWeapon is IActivatableWeapon) {
            if (IActivatableWeapon(currentWeapon).canActivate(_coords.elemX, _coords.elemY, this))
                EngineContext.triedToUseWeapon.dispatch(playerId, _coords.elemX, _coords.elemY, currentWeapon.type);
        }

    }

    public function get currentWeapon():IWeapon {
        return _currentWeapon;
    }

    public function activateWeapon():void {
        if (currentWeapon is IActivatableWeapon) {
            IActivatableWeapon(currentWeapon).activate(_coords.elemX, coords.elemY, this);
        }
    }

    public function deactivateWeapon():void {
        if (currentWeapon is IDeactivatableWeapon) {
            IDeactivatableWeapon(currentWeapon).deactivate(_coords.elemX, coords.elemY, this);
        }
    }
}
}