import { Meteor } from 'meteor/meteor';
import numbro from 'numbro';

const stakingFraction = Meteor.settings.public.stakingFraction;
const powerReduction = Meteor.settings.public.powerReduction || stakingFraction;
const votingPowerDisplayRatio = Meteor.settings.public.displayVotingPowerByPowerReduction ? powerReduction / stakingFraction : 1;

export function votingPowerForDisplay(power) {
    return power * votingPowerDisplayRatio;
}

export function numbroVotingPower(power) {
    return numbro(votingPowerForDisplay(power));
}