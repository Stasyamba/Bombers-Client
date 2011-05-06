/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import components.common.items.ItemProfileObject
import components.common.items.categories.ItemCategory

import engine.EngineContext
import engine.bombers.interfaces.IMapCoords
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombers.mapInfo.MapCoords
import engine.bombss.BombType
import engine.data.Consts
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

    private var _standStill:Boolean = true

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
    private var _waitingToACK:Boolean = false

    //Array of MoveTickObject
    private var _moveTicksArray:Array = new Array()
    private var _interpolModifier:Number = 1
    private const START_INTERPOL_TIME:int = 800
    private const MOVE_INTERPOL_TIME:int = 400
    private const MIN_INTERPOL_MOD:Number = 0.85
    private const MAX_INTERPOL_MOD:Number = 1.15
    private var _ignoreInterpolationFor:int = 0

    private var _moveToTarget:MoveTickObject = null

    private var _lastX:Number = -1
    private var _lastY:Number = -1
    private var _checkWrongWay:int = 0

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
        if(!Context.gameModel.isPlayingNow || isDead)
            return
        if (_sendTime + miliSecs > 50 && _waitingToSend) {
            Context.gameServer.sendPlayerDirectionChanged(coords.getRealX(), coords.getRealY(), _standStill ? Direction.NONE : _serverDir, false)
            _sendTime = 0
            _waitingToSend = false
            _waitingToACK = !_standStill
        } else
            _sendTime += miliSecs
    }

    private function onMoveTick(obj:Object):void {
        if (!Context.gameModel.isPlayingNow || isDead)
            return
        var tickObject:MoveTickObject = obj[slot]
        if (tickObject == null)
            return

        //greenBaloon
        if (!_coords.correctCoords(tickObject.x, tickObject.y)) {
        } else {
            EngineContext.greenBaloon.dispatch(tickObject.x, tickObject.y, tickObject.dir)
        }

        if (_waitingToACK) {
            if (tickObject.dir != _serverDir)
                return
            _waitingToACK = false
        }

        if ((_coords.getRealX() != tickObject.x && _coords.getRealY() != tickObject.y ) ||
                Math.abs(_coords.getRealX() - tickObject.x) > Consts.BLOCK_SIZE ||
                Math.abs(_coords.getRealY() - tickObject.y) > Consts.BLOCK_SIZE ||
                diffWays(tickObject)) {

            _coords.setExplicit(tickObject.x, tickObject.y)

            _lastX = tickObject.x;
            _lastY = tickObject.y
            _ignoreInterpolationFor = 0
            _moveToTarget = null
            EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());

        } else {
            if (tickObject.dir == Direction.NONE) {
                _moveToTarget = tickObject
                return
            }
            if (_ignoreInterpolationFor == 0) {
                var diff:Number = getDiffTo(tickObject);
                var realDir:Direction = getDirByTicks(tickObject)

                if (realDir == Direction.LEFT || realDir == Direction.UP)
                    diff = -diff
                diff -= Context.gameServer.averagePing * speed / 1000
                _interpolModifier = 1 + diff * 1000 / (speed * MOVE_INTERPOL_TIME)
                if (_interpolModifier > MAX_INTERPOL_MOD)
                    _interpolModifier = MAX_INTERPOL_MOD
                if (_interpolModifier < MIN_INTERPOL_MOD)
                    _interpolModifier = MIN_INTERPOL_MOD
                _ignoreInterpolationFor = MOVE_INTERPOL_TIME
            }
        }

        if (!_waitingToSend && !_standStill && _serverDir != tickObject.dir) {
            _serverDir = tickObject.dir
            updateInputDirection()
        }

        _moveTicksArray.unshift(tickObject)
        if (_moveTicksArray.length > 10) {
            _moveTicksArray.pop()
        }
    }

    private function diffWays(tickObject:MoveTickObject):Boolean {
        if (_checkWrongWay > 0) {
            var prevMTO:MoveTickObject = _moveTicksArray[0]
            _checkWrongWay--
            if (prevMTO == null || _lastX == -1 || _prevDir.isOppositeTo(_serverDir)) return false
            return (Point.distance(new Point(prevMTO.x, prevMTO.y), new Point(_lastX, _lastY)) >
                    Point.distance(new Point(tickObject.x, tickObject.y), new Point(_coords.getRealX(), _coords.getRealY())))
        }
        return false
    }

    private function getDiffTo(tickObject:MoveTickObject):Number {
        if (_coords.getRealX() != tickObject.x)
            return _coords.getRealX() - tickObject.x
        return _coords.getRealY() - tickObject.y
    }


    private function getDirByTicks(tickObject:MoveTickObject):Direction {
        var prevMTO:MoveTickObject = _moveTicksArray[0]
        if (tickObject.x > prevMTO.x)
            return Direction.RIGHT
        if (tickObject.x < prevMTO.x)
            return Direction.LEFT
        if (tickObject.y > prevMTO.y)
            return Direction.DOWN
        if (tickObject.y < prevMTO.y)
            return Direction.UP
        return Direction.NONE
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

    private function goTo(dir:Direction, moveAmount:Number, coords:IMapCoords = null):void {
        var c:IMapCoords = coords == null ? _coords : coords
        switch (dir) {
            case Direction.LEFT:
                c.stepLeft(moveAmount, _spectatorMode);
                break;
            case Direction.RIGHT:
                c.stepRight(moveAmount, _spectatorMode);
                break;
            case Direction.UP:
                c.stepUp(moveAmount, _spectatorMode);
                break;
            case Direction.DOWN:
                c.stepDown(moveAmount, _spectatorMode);
                break;
        }
    }

    public function performMotion(moveAmount:Number):void {
        var dir:Direction = _serverDir
        if (_serverDir == Direction.NONE && !_spectatorMode) {
            if (_moveToTarget) {
                var diff:Number = Math.abs(getDiffTo(_moveToTarget))
                if (diff < 10e-3) {
                    _moveToTarget = null
                    return
                }
                dir = getDirToTarget(_moveToTarget)
                moveAmount = diff > moveAmount ? moveAmount : diff
            } else {
                return
            }
        }
        _lastX = _coords.getRealX();
        _lastY = _coords.getRealY();

        goTo(dir, moveAmount)

        if (_lastX != _coords.getRealX() || _lastY != _coords.getRealY()) {
            EngineContext.playerCoordinatesChanged.dispatch(_coords.getRealX(), _coords.getRealY());
            if (_standStill) {
                _waitingToSend = true
                _standStill = false
            }
        } else {
            if (!_standStill) {
                _waitingToSend = true
                _standStill = true
            }
        }
    }

    private function getDirToTarget(_moveToTarget:MoveTickObject):Direction {
        if (_moveToTarget.x > _coords.getRealX())
            return Direction.RIGHT
        if (_moveToTarget.x < coords.getRealX())
            return Direction.LEFT
        if (_moveToTarget.y > coords.getRealY())
            return Direction.DOWN
        if (_moveToTarget.y < coords.getRealY())
            return Direction.UP
        return Direction.NONE
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
        var p:int = Context.gameServer.averagePing

        if (_prevDir != _direction.direction) {
            _serverDir = _direction.direction
            _standStill = false
            _waitingToSend = true
            _moveToTarget = null


            if (_prevDir == Direction.NONE) {

                _interpolModifier = START_INTERPOL_TIME / (p + START_INTERPOL_TIME)
                if (_interpolModifier < MIN_INTERPOL_MOD)
                    _interpolModifier = MIN_INTERPOL_MOD
                _ignoreInterpolationFor = START_INTERPOL_TIME
            } else

            if (_serverDir.isTurnTo(_prevDir)) {
                var lastTick:MoveTickObject = _moveTicksArray[0]
                var dir:Direction = _prevDir
                var ccc:MapCoords = new MapCoords(this, Context.game.mapManager.map, 0, 0, 0, 0)
                ccc.setExplicit(lastTick.x, lastTick.y)
                goTo(dir, speed * (p + int(new Date().getTime()) - lastTick.time) / 1000, ccc)
                if (willTurnGood(ccc)) {
                    //do nothing
                } else {
                    EngineContext.pingChanged.dispatch(new Point(ccc.getRealX(), ccc.getRealY()))
                    _coords.setExplicit(ccc.getRealX(), ccc.getRealY())
                }
                _checkWrongWay = 2
            }

            updateInputDirection()
        }
    }

    private function willTurnGood(ccc:MapCoords):Boolean {
        if (ccc.elemX == _coords.elemX && ccc.elemY == _coords.elemY)
            return  ((ccc.xDef * _coords.xDef > 0) || (ccc.yDef * _coords.yDef > 0))
        if (ccc.elemX == _coords.elemX - 1)
            return ccc.xDef > 0 && _coords.xDef < 0
        if (ccc.elemX == _coords.elemX + 1)
            return ccc.xDef < 0 && _coords.xDef > 0
        if (ccc.elemY == _coords.elemY - 1)
            return ccc.yDef > 0 && _coords.yDef < 0
        if (ccc.elemY == _coords.elemY + 1)
            return ccc.yDef < 0 && _coords.yDef > 0
        return false
    }

    public override function move(elapsedMilliSecs:int):void {
        performMotion(elapsedMilliSecs * speed * _interpolModifier / 1000)
        if (_ignoreInterpolationFor > 0) {
            _ignoreInterpolationFor = _ignoreInterpolationFor - elapsedMilliSecs >= 0 ? _ignoreInterpolationFor - elapsedMilliSecs : 0
        }
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


