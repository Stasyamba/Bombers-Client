/*
 * Copyright (c) 2010.
 * Pavkin Vladimir
 */

package engine.bombers.mapInfo {
import engine.EngineContext
import engine.bombers.CreatureBase
import engine.bombers.interfaces.IMapCoords
import engine.data.Consts
import engine.maps.IMap
import engine.maps.interfaces.IMapBlock
import engine.maps.mapBlocks.NullMapBlock
import engine.utils.Direction
import engine.utils.Utils

import flash.geom.Point

public class MapCoords implements IMapCoords {

    private var _elemX:uint = 0;
    private var _elemY:uint = 0;
    private var _xDef:Number = 0;
    private var _yDef:Number = 0;

    private var map:IMap;

    private var horDefFunc:Function;
    private var vertDefFunc:Function;

    private var _owner:CreatureBase

    public function MapCoords(owner:CreatureBase, map:IMap, elemX:uint, elemY:uint, xDef:Number, yDef:Number):void {
        _owner = owner
        _elemX = elemX;
        _elemY = elemY;
        _xDef = xDef;
        _yDef = yDef;
        this.map = map;
    }

    public function get elemX():uint {
        return _elemX
    }

    public function set elemX(value:uint):void {
        if (value < 0)
            value = 0;
        else if (value >= map.width)
            value = map.width - 1;
        else
            _elemX = value
    }

    public function get elemY():uint {
        return _elemY
    }

    public function set elemY(value:uint):void {
        if (value < 0)
            value = 0;
        else if (value >= map.height)
            value = map.height - 1;
        else
            _elemY = value
    }

    public function get xDef():Number {
        return _xDef
    }

    public function set xDef(value:Number):void {
        if (isValueWithinBlock(value))
            _xDef = value;
        else if (isPlusOverflow(value)) {
            processRightOverflow(value)
        }
        else if (isMinusOverflow(value)) {
            processLeftOverflow(value)
        }
    }

    public function get yDef():Number {
        return _yDef
    }

    public function set yDef(value:Number):void {
        if (isValueWithinBlock(value))
            _yDef = value;
        else if (isPlusOverflow(value)) {
            processDownOverflow(value)
        }
        else if (isMinusOverflow(value)) {
            processUpOverflow(value)
        }
    }

    private function processLeftOverflow(value:Number):void {
        if (elemX - getBlocksCount(value) < 0) {
            elemX = 0;
            _xDef = 0;
        } else {
            elemX -= getBlocksCount(value);
            _xDef = Consts.BLOCK_END - getDeflection(value);
        }
    }

    private function processRightOverflow(value:Number):void {
        if (elemX + getBlocksCount(value) >= map.width) {
            elemX = map.width - 1;
            _xDef = 0;
        } else {
            elemX += getBlocksCount(value);
            _xDef = Consts.BLOCK_START + getDeflection(value);
        }
    }

    private function processUpOverflow(value:Number):void {
        if (elemY - getBlocksCount(value) < 0) {
            elemY = 0;
            _yDef = 0;
        } else {
            elemY -= getBlocksCount(value);
            _yDef = Consts.BLOCK_END - getDeflection(value);
        }
    }

    private function processDownOverflow(value:Number):void {
        if (elemY + getBlocksCount(value) >= map.height) {
            elemY = map.height - 1;
            _yDef = 0;
        } else {
            elemY += getBlocksCount(value);
            _yDef = Consts.BLOCK_START + getDeflection(value);
        }
    }

    private function isMinusOverflow(value:Number):Boolean {
        return value < Consts.BLOCK_START;
    }

    private function isPlusOverflow(value:Number):Boolean {
        return value >= Consts.BLOCK_END;
    }

    private function getDeflection(value:Number):Number {
        return (Math.abs(value) - Consts.BLOCK_SIZE_2) % Consts.BLOCK_SIZE
    }

    private function getBlocksCount(value:Number):uint {
        return int((Math.abs(value) - Consts.BLOCK_SIZE_2) / Consts.BLOCK_SIZE) + 1;
    }

    private function isValueWithinBlock(value:Number):Boolean {
        return Utils.between(Consts.BLOCK_START, value, Consts.BLOCK_END) && value != Consts.BLOCK_END
    }


    public function getRealX():Number {
        return elemX * Consts.BLOCK_SIZE + xDef;
    }

    public function getRealY():Number {
        return elemY * Consts.BLOCK_SIZE + yDef;
    }


    // Movement

    /*
     * removeDeflection functions move player to eliminate corresponding deflection
     * result - movement points left after removing deflection
     */
    protected function removeRightDeflection(moveAmount:Number):Number {

        if (xDef == 0) return moveAmount;

        var result:Number;

        if (isEnoughMoveAmountX(0, moveAmount)) {
            result = moveAmount - xDef;
            xDef = 0;
        } else {
            result = 0;
            xDef -= moveAmount;
        }
        return result;
    }

    protected function removeLeftDeflection(moveAmount:Number):Number {

        if (xDef == 0) return moveAmount;

        var result:Number;

        if (isEnoughMoveAmountX(-moveAmount, 0)) {
            result = moveAmount - Math.abs(xDef);    //xDef < 0
            xDef = 0;
        } else {
            result = 0;
            xDef += moveAmount;
        }
        return result;
    }

    protected function removeUpDeflection(moveAmount:Number):Number {

        if (yDef == 0) return moveAmount;

        var result:Number;

        if (isEnoughMoveAmountY(-moveAmount, 0)) {
            result = moveAmount + yDef;
            yDef = 0;
        } else {
            result = 0;
            yDef += moveAmount;
        }
        return result;
    }

    protected function removeDownDeflection(moveAmount:Number):Number {

        if (yDef == 0) return moveAmount;

        var result:Number;

        if (isEnoughMoveAmountY(0, moveAmount)) {
            result = moveAmount - yDef;
            yDef = 0;
        } else {
            result = 0;
            yDef -= moveAmount;
        }
        return result;
    }

    private function isEnoughMoveAmountX(x1:Number, x2:Number):Boolean {
        return Utils.between(x1, xDef, x2)
    }

    private function isEnoughMoveAmountY(x1:Number, x2:Number):Boolean {
        return Utils.between(x1, yDef, x2)
    }

    public function canMoveLeft():Boolean {
        var b:IMapBlock = map.getNeighbour(elemX, elemY, Direction.LEFT);
        return b.canGoThrough(_owner);
    }

    public function canMoveRight():Boolean {
        var b:IMapBlock = map.getNeighbour(elemX, elemY, Direction.RIGHT);
        return b.canGoThrough(_owner);
    }

    public function canMoveUp():Boolean {
        var b:IMapBlock = map.getNeighbour(elemX, elemY, Direction.UP);
        return b.canGoThrough(_owner);
    }

    public function canMoveDown():Boolean {
        var b:IMapBlock = map.getNeighbour(elemX, elemY, Direction.DOWN);
        return b.canGoThrough(_owner);
    }

    private function canMoveLeftNext():Boolean {
        if (elemX == 0)
            return false;
        if (yDef == 0)    // means no 'next' block
            return false;
        var bThrough:IMapBlock;
        var bTarget:IMapBlock;

        if (yDef > 0) //down
        {
            bThrough = map.getNeighbour(elemX, elemY, Direction.DOWN);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX - 1, elemY + 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        } else {  //up
            bThrough = map.getNeighbour(elemX, elemY, Direction.UP);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX - 1, elemY - 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        }
    }

    private function canMoveRightNext():Boolean {
        if (elemX == map.width - 1)
            return false;
        if (yDef == 0)
            return false;
        var bThrough:IMapBlock;
        var bTarget:IMapBlock;

        if (yDef > 0) //down
        {
            bThrough = map.getNeighbour(elemX, elemY, Direction.DOWN);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX + 1, elemY + 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        } else {  //up
            bThrough = map.getNeighbour(elemX, elemY, Direction.UP);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX + 1, elemY - 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        }
    }

    private function canMoveUpNext():Boolean {
        if (elemY == 0)
            return false;
        if (xDef == 0)
            return false;
        var bThrough:IMapBlock;
        var bTarget:IMapBlock;

        if (xDef > 0) //right
        {
            bThrough = map.getNeighbour(elemX, elemY, Direction.RIGHT);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX + 1, elemY - 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        } else {  //left
            bThrough = map.getNeighbour(elemX, elemY, Direction.LEFT);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX - 1, elemY - 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        }
    }

    private function canMoveDownNext():Boolean {
        if (elemY == map.height - 1)
            return false;
        if (xDef == 0)
            return false;
        var bThrough:IMapBlock;
        var bTarget:IMapBlock;

        if (xDef > 0) //right
        {
            bThrough = map.getNeighbour(elemX, elemY, Direction.RIGHT);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX + 1, elemY + 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        } else {  //left
            bThrough = map.getNeighbour(elemX, elemY, Direction.LEFT);
            if (bThrough == NullMapBlock.getInstance())
                return false
            bTarget = map.getBlock(elemX - 1, elemY + 1);
            return bThrough.canGoThrough(_owner) && bTarget.canGoThrough(_owner);
        }
    }

    public function stepLeft(moveAmount:Number, spectatorMode:Boolean = false):void {
        if (spectatorMode) {
            if (elemX > 0)
                xDef -= moveAmount
            else if (xDef > 0)
                xDef = xDef - moveAmount > 0 ? xDef - moveAmount : 0
        }
        horDefFunc = null;
        var remains:Number = removeRightDeflection(moveAmount);
        if (canMoveLeft()) {
            if (vertDefFunc == null)
                vertDefFunc = yDef > 0 ? removeDownDeflection : removeUpDeflection;
            xDef -= (remains < moveAmount) ? remains : vertDefFunc(moveAmount);
        } else {
            if (canMoveLeftNext()) {
                if (vertDefFunc == null)
                    vertDefFunc = yDef > 0 ? removeUpDeflection : removeDownDeflection;
                xDef -= vertDefFunc(moveAmount);
            }
        }
    }

    public function stepRight(moveAmount:Number, spectatorMode:Boolean = false):void {
        if (spectatorMode) {
            if (elemX < map.width - 1)
                xDef += moveAmount
            else if (xDef < 0)
                xDef = xDef + moveAmount < 0 ? xDef + moveAmount : 0
        }
        horDefFunc = null;
        var remains:Number = removeLeftDeflection(moveAmount);
        if (canMoveRight()) {
            if (vertDefFunc == null)
                vertDefFunc = yDef > 0 ? removeDownDeflection : removeUpDeflection;
            xDef += (remains < moveAmount) ? remains : vertDefFunc(moveAmount);
        } else {
            if (canMoveRightNext()) {
                if (vertDefFunc == null)
                    vertDefFunc = yDef > 0 ? removeUpDeflection : removeDownDeflection;
                xDef += vertDefFunc(moveAmount);
            }
        }
    }

    public function stepUp(moveAmount:Number, spectatorMode:Boolean = false):void {
        if (spectatorMode) {
            if (elemY > 0)
                yDef -= moveAmount
            else if (yDef > 0)
                yDef = yDef - moveAmount > 0 ? yDef - moveAmount : 0
        }
        vertDefFunc = null;
        var remains:Number = removeDownDeflection(moveAmount);
        if (canMoveUp()) {
            if (horDefFunc == null)
                horDefFunc = xDef > 0 ? removeRightDeflection : removeLeftDeflection;
            yDef -= (remains < moveAmount) ? remains : horDefFunc(moveAmount);
        } else {
            if (canMoveUpNext()) {
                if (horDefFunc == null)
                    horDefFunc = xDef > 0 ? removeLeftDeflection : removeRightDeflection;
                yDef -= horDefFunc(moveAmount);
            }
        }
    }

    public function stepDown(moveAmount:Number, spectatorMode:Boolean = false):void {
        if (spectatorMode) {
            if (elemY < map.height - 1)
                yDef += moveAmount
            else if (yDef < 0)
                yDef = yDef + moveAmount < 0 ? yDef + moveAmount : 0
        }
        vertDefFunc = null;
        var remains:Number = removeUpDeflection(moveAmount);
        if (canMoveDown()) {
            if (horDefFunc == null)
                horDefFunc = xDef > 0 ? removeRightDeflection : removeLeftDeflection;
            yDef += (remains < moveAmount) ? remains : horDefFunc(moveAmount);
        } else {
            if (canMoveDownNext()) {
                if (horDefFunc == null)
                    horDefFunc = xDef > 0 ? removeLeftDeflection : removeRightDeflection;
                yDef += horDefFunc(moveAmount);
            }
        }
    }

    public function getPartBlock():IMapBlock {
        if (xDef > 0)
            return map.getNeighbour(elemX, elemY, Direction.RIGHT);
        if (xDef < 0)
            return map.getNeighbour(elemX, elemY, Direction.LEFT);
        if (yDef > 0)
            return map.getNeighbour(elemX, elemY, Direction.DOWN);
        if (yDef < 0)
            return map.getNeighbour(elemX, elemY, Direction.UP);
        return NullMapBlock.getInstance();
    }

    public function getPartBlockDef():Number {
        if (xDef != 0)
            return Math.abs(xDef);
        return Math.abs(yDef);
    }

    public function setExplicit(x:Number, y:Number):void {

        horDefFunc = null
        vertDefFunc = null

        elemX = int((x + Consts.BLOCK_SIZE_2) / Consts.BLOCK_SIZE);
        _xDef = (x + Consts.BLOCK_SIZE_2) % Consts.BLOCK_SIZE - Consts.BLOCK_SIZE_2;

        elemY = int((y + Consts.BLOCK_SIZE_2) / Consts.BLOCK_SIZE);
        _yDef = (y + Consts.BLOCK_SIZE_2) % Consts.BLOCK_SIZE - Consts.BLOCK_SIZE_2;
    }

    public function block():IMapBlock {
        return map.getBlock(elemX, elemY)
    }


    public function correctCoords(x:Number, y:Number):Boolean {
        var eX:int = int(x / Consts.BLOCK_SIZE);
        var eY:int = int(y / Consts.BLOCK_SIZE);
        var xD:Number = x % Consts.BLOCK_SIZE;
        var yD:Number = y % Consts.BLOCK_SIZE;

        if (xD != 0 && yD != 0) {
            EngineContext.redBaloon.dispatch(new Point(x, y), 0)
            return false
        }
        if (!map.getBlock(eX, eY).canGoThrough(_owner)) {
            EngineContext.redBaloon.dispatch(new Point(x, y), 1)
            return false
        }
        var pb:IMapBlock

        var d:int = 2
        if (yD != 0) d = 3

        if (xD > 0)
            pb = map.getNeighbour(eX, eY, Direction.RIGHT);
        if (xD < 0)
            pb = map.getNeighbour(eX, eY, Direction.LEFT);
        if (yD > 0)
            pb = map.getNeighbour(eX, eY, Direction.DOWN);
        if (yD < 0)
            pb = map.getNeighbour(eX, eY, Direction.UP);

        if (pb != null && !pb.canGoThrough(_owner)) {
            EngineContext.redBaloon.dispatch(new Point(x, y), d)
            return false
        }
        return true
    }
}
}