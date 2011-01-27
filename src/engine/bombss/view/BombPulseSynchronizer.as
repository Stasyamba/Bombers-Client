/*
 * Copyright (c) 2011.
 * Pavkin Vladimir
 */

package engine.bombss.view {
import engine.EngineContext
import engine.data.Consts

public class BombPulseSynchronizer {

    private static var _instance:BombPulseSynchronizer

    private static const UP:int = 1;
    private static const DOWN:int = -1;

    private var pulseMaxSize:Number = Consts.BLOCK_SIZE;
    private var pulseSize:Number = Consts.BLOCK_SIZE;
    private var pulseMinSize:Number = Consts.BLOCK_SIZE - 4;

    private var pulsingSpeed:Number;
    private var pulsingDir:int;

    private var fastPulsingSpeed:Number;
    private var fastPulseSize:Number = Consts.BLOCK_SIZE;
    private var fastPulsingDir:int;

    function BombPulseSynchronizer() {
        EngineContext.frameEntered.add(onPulse);
        startPulsing();
    }

    public static function get instance():BombPulseSynchronizer {
        if (!_instance)
            _instance = new BombPulseSynchronizer()
        return _instance;
    }

    private function startPulsing():void {
        pulsingDir = fastPulsingDir = DOWN;
        pulsingSpeed = 15;
        fastPulsingSpeed = 50;
        pulseSize = fastPulseSize = pulseMaxSize;
    }

    private function onPulse(elapsedMilliSecs:int):void {
        pulseSize += pulsingDir * pulsingSpeed * elapsedMilliSecs / 1000;
        if (pulseSize <= pulseMinSize || pulseSize >= pulseMaxSize) {
            pulsingDir = -pulsingDir;
            pulseSize = pulseSize <= pulseMinSize ? pulseMinSize : pulseMaxSize;
        }

        fastPulseSize += fastPulsingDir * fastPulsingSpeed * elapsedMilliSecs / 1000;
        if (fastPulseSize <= pulseMinSize || fastPulseSize >= pulseMaxSize) {
            fastPulsingDir = -fastPulsingDir;
            fastPulseSize = fastPulseSize <= pulseMinSize ? pulseMinSize : pulseMaxSize;
        }
    }

    public static function get pulseOffset():Number {
        return (instance.pulseMaxSize - instance.pulseSize) / 2;
    }

    public static function get pulseScale():Number {
        return instance.pulseSize / instance.pulseMaxSize;
    }

    public static function get fastOffset():Number {
        return (instance.pulseMaxSize - instance.fastPulseSize) / 2;
    }

    public static function get fastScale():Number {
        return instance.fastPulseSize / instance.pulseMaxSize;
    }
}
}
