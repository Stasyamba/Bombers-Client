/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.items.ItemProfileObject
import components.common.items.categories.ItemCategory

import engine.EngineContext
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombss.BombType
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.profiles.GameProfile
import engine.utils.Direction
import engine.weapons.NullWeapon
import engine.weapons.WeaponBuilder
import engine.weapons.WeaponType
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IDeactivatableWeapon
import engine.weapons.interfaces.IWeapon

import flash.geom.Point

public class PlayerBomber extends BomberBase implements IPlayerBomber {

    private var _prevDir:Direction = Direction.NONE
    private var _serverDir:Direction = Direction.NONE;
    private var _direction:InputDirection;


    private var _gameProfile:GameProfile
    /*
     * use BombersBuilder instead
     * */
    protected var _weaponBuilder:WeaponBuilder;
    protected var _currentWeapon:IWeapon
    protected var _weapons:Array = new Array()
    private var _spectatorMode:Boolean = false


    private var _sendTime:int = 0
    private var _waitingToSend:Boolean = false


    public function PlayerBomber(game:IGame, slot:int, gameProfile:GameProfile, color:PlayerColor, direction:InputDirection, weaponBuilder:WeaponBuilder) {
        super(game, slot, gameProfile.currentBomberType, gameProfile.nick, color, Context.imageService.bomberSkin(gameProfile.currentBomberType), gameProfile.aursTurnedOn);

        _weaponBuilder = weaponBuilder
        this._gameProfile = gameProfile
        for (var i:int = 0; i < _gameProfile.gotItems.length; i++) {
            var ipo:ItemProfileObject = _gameProfile.gotItems[i];
            if (Context.Model.itemsCategoryManager.getItemCategory(ipo.itemType) == ItemCategory.WEAPON) {
                _weapons[ipo.itemType.value] = weaponBuilder.fromItemType(ipo.itemType, ipo.itemCount)
            }
        }
        if (gameProfile.selectedWeaponLeftHand != null)
            _currentWeapon = _weapons[gameProfile.selectedWeaponLeftHand.itemType.value]
        _direction = direction;
        _serverDir = Direction.NONE

        EngineContext.moveTick.add(onMoveTick)
        EngineContext.currentWeaponChanged.add(onCurrentWeaponChanged)
        EngineContext.weaponUnitSpent.add(onWeaponUnitSpent)
        EngineContext.playerDied.addOnce(function():void {
            _spectatorMode = true;
        })
    }

    public function sendDirection(miliSecs:int):void {
        if (_sendTime + miliSecs > 100 && _waitingToSend) {
            _sendTime = 0
            _waitingToSend = false
            Context.gameServer.sendPlayerDirectionChanged(coords.getRealX(), coords.getRealY(), _serverDir, false)
        } else
            _sendTime += miliSecs
    }

    private function onMoveTick(obj:Object):void {
        if (!Context.gameModel.isPlayingNow)
            return
        var tickObject:Object = obj[slot]
        if(tickObject == null)
            return
//        var xPogr:Number = Math.abs(tickObject.x - Math.round(tickObject.x))
//        var yPogr:Number = Math.abs(tickObject.y - Math.round(tickObject.y))
//        if (xPogr < 10e-6)
//            tickObject.x = Math.round(tickObject.x)
//
//        if (yPogr < 10e-6)
//            tickObject.y = Math.round(tickObject.y)


        _coords.setExplicit(tickObject.x,tickObject.y)

        EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());

        if (!_coords.correctCoords(tickObject.x, tickObject.y)) {
        } else {
            EngineContext.greenBaloon.dispatch(tickObject.x, tickObject.y, tickObject.dir)
        }

        if (!_waitingToSend && _serverDir != tickObject.dir) {
            _serverDir = tickObject.dir
            updateInputDirection()
        }
    }

    private function onWeaponUnitSpent(type:WeaponType):void {
        for (var i:int = 0; i < Context.Model.currentSettings.gameProfile.gotItems.length; i++) {
            var obj:ItemProfileObject = Context.Model.currentSettings.gameProfile.gotItems[i];
            if (obj.itemType.value == type.value) {
                obj.itemCount--;
                break
            }
        }
        Context.Model.dispatchCustomEvent(ContextEvent.GP_CURRENT_LEFT_WEAPON_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_GOTITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GP_PACKITEMS_IS_CHANGED)
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_UPDATE_GAME_WEAPONS);
    }

    private function onCurrentWeaponChanged():void {
        if (_gameProfile.selectedWeaponLeftHand != null)
            _currentWeapon = _weapons[_gameProfile.selectedWeaponLeftHand.itemType.value]
        else
            _currentWeapon = NullWeapon.instance
    }

    public function performMotion(moveAmount:Number):void {
        if (_serverDir == Direction.NONE)
            return;
        var x:int = _coords.getRealX();
        var y:int = _coords.getRealY();

        switch (_serverDir) {
            case Direction.LEFT:
                _coords.stepLeft(moveAmount, _spectatorMode);
                break;
            case Direction.RIGHT:
                _coords.stepRight(moveAmount, _spectatorMode);
                break;
            case Direction.UP:
                _coords.stepUp(moveAmount, _spectatorMode);
                break;
            case Direction.DOWN:
                _coords.stepDown(moveAmount, _spectatorMode);
                break;
        }
        if (x != _coords.getRealX() || y != _coords.getRealY()) {
            EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());
        }
    }

    private function updateInputDirection():void {
        EngineContext.playerInputDirectionChanged.dispatch(_coords.getRealX(), _coords.getRealY(), _serverDir, false)
    }

    public function addDirection(m:Direction):void {
        _prevDir = _serverDir;
        _direction.addDirection(m);

        checkNewDir()
    }

    public function removeDirection(m:Direction):void {
        _prevDir = _serverDir;
        _direction.removeDirection(m);

        checkNewDir()
    }

    private function checkNewDir():void {
        if (_prevDir != _direction.direction) {
            _serverDir = _direction.direction
            _waitingToSend = true
            updateInputDirection()
        }
    }

    public override function move(elapsedMilliSecs:int):void {
        performMotion(elapsedMilliSecs * speed / 1000)
    }

    public function setBomb(bombType:BombType):void {
        trace(">>> " + _map.getBlock(coords.elemX, coords.elemY).canSetBomb() + " " + bombCount)
        if (_map.getBlock(coords.elemX, coords.elemY).canSetBomb() && bombCount > 0 && !isDead) {
            trace("tried to set when left " + bombCount)
            EngineContext.triedToActivateWeapon.dispatch(slot, coords.elemX, coords.elemY, WeaponType.byValue(bombType.value));
        }
    }

    public override function explode(expl:IExplosion):void {
        hit(expl.damage)
    }


    public function hit(dmg:int):void {
        if (dmg <= 0) //smoke explosion
            return
        hitWithoutImmortal(dmg)
        if (!isDead)
            super.makeImmortalFor(immortalTime);
    }


    public function hitWithoutImmortal(dmg:int):void {
        if (dmg <= 0) //smoke explosion
            return
        life -= dmg;
        if (life < 0) life = 0;

        EngineContext.playerDamaged.dispatch(dmg, isDead)
        if (isDead) {
            EngineContext.playerDied.dispatch();
        }
    }

    public override function kill():void {
        EngineContext.playerDied.dispatch();
        EngineContext.playerDamaged.dispatch(_life, true);
        life = 0;
    }

    public function tryActivateWeapon():void {
        if (isDead) return;
        if (currentWeapon is IActivatableWeapon) {
            if (IActivatableWeapon(currentWeapon).canActivate(_coords.elemX, _coords.elemY, this))
                EngineContext.triedToActivateWeapon.dispatch(slot, _coords.elemX, _coords.elemY, currentWeapon.type);
        }

    }

    public function get currentWeapon():IWeapon {
        return _currentWeapon;
    }

    public function activateWeapon(x:int, y:int, type:WeaponType):void {
        if (_weapons[type.value] is IActivatableWeapon) {
            (_weapons[type.value] as IActivatableWeapon).activate(x, y, this);
            EngineContext.weaponUnitSpent.dispatch(type)
        }
    }

    public function deactivateWeapon(type:WeaponType):void {
        if (_weapons[type.value] is IDeactivatableWeapon) {
            (_weapons[type.value] as IDeactivatableWeapon).deactivate(this);
        }
    }

    override public function set life(life:int):void {
        super.life = life
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    override public function incSpeed():void {
        super.incSpeed()
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    override public function incBombCount():void {
        super.incBombCount()
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    override public function incBombPower():void {
        super.incBombPower()
        Context.Model.dispatchCustomEvent(ContextEvent.GPAGE_MY_PARAMETERS_IS_CHANGED)

    }

    public function decWeapon(wt:WeaponType):void {
        if (_weapons[wt.value] is IActivatableWeapon) {
            (_weapons[wt.value] as IActivatableWeapon).decCharges()
        }
    }

    override public function get direction():Direction {
        return _serverDir
    }
}
}