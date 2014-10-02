if chargeUpTime<=chargeUp
{
    shooting=true
    script_execute(shootingScript)
    var spreadArc = bulletArc/2
    var spreadOffset = bulletOffset/2
    repeat(bulletNum)
    {
        var inacArc = random(inaccuracyArc * 2) - inaccuracyArc;
        var aimMode = 0
        if client=false
        {
            var o = oServerProjectile
            if image_xscale=1
            {
                var instProj = instance_create(x + lengthdir_x(24.1868, aimAngle+7.12502) + lengthdir_x(spreadOffset, aimAngle+97.12502),y + 23 + lengthdir_y(24.1868, aimAngle+7.12502) + lengthdir_y(spreadOffset, aimAngle+97.12502),o);
            }
            else
            {
                var instProj = instance_create(x - lengthdir_x(24.1868, aimAngle-7.12502) - lengthdir_x(spreadOffset, aimAngle+97.12502),y + 23 - lengthdir_y(24.1868, aimAngle-7.12502) - lengthdir_y(spreadOffset, aimAngle+97.12502),o);
                aimMode=180
            }
            instProj.speed = bulletSpd
            instProj.direction = aimAngle + inacArc + aimMode + spreadArc
            instProj.owner = id
        }
        else if image_xscale=-1
        {
            changeTimeStamps[4]=current_time
            aimMode=180
        }
        //SendBullet(instProj)
        if bulletNum>1
        {
            spreadArc -= bulletArc/(bulletNum-1)
            spreadOffset -= bulletOffset/(bulletNum-1)
        }
        recoilSpeed = recoil
        recoilDirection = -aimAngle + aimMode
    }
    if bulletStringN<bulletString
    {
        rofcd = bulletStringCD
        bulletStringN++
    }
    else
    {
        shooting=false
        bulletStringN=0
        rofcd = rof
    }
}
else
    chargeUp++
