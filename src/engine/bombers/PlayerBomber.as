/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers {
import engine.EngineContext
import engine.bombers.interfaces.IGameSkills
import engine.bombers.interfaces.IPlayerBomber
import engine.bombers.mapInfo.InputDirection
import engine.bombers.skin.BomberSkin
import engine.bombss.BombType
import engine.bombss.BombsBuilder
import engine.explosionss.interfaces.IExplosion
import engine.games.IGame
import engine.playerColors.PlayerColor
import engine.utils.Direction
import engine.weapons.interfaces.IActivatableWeapon
import engine.weapons.interfaces.IWeapon

public class PlayerBomber extends BomberBase implements IPlayerBomber {

    private var _direction:InputDirection;

    private var lastViewDir:Direction = Direction.NONE;
    /*
     * use BombersBuilder instead
     * */
    public function PlayerBomber(game:IGame, playerId:int, userName:String, color:PlayerColor, direction:InputDirection, skills:IGameSkills, weapon:IWeapon, skin:BomberSkin, bombBuilder:BombsBuilder) {
        super(game, playerId, userName, color, weapon, skin, bombBuilder);

        _direction = direction;
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

}
}