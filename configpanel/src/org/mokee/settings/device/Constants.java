/*
 * Copyright (C) 2016 The CyanogenMod Project
 *           (C) 2017-2018 The LineageOS Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.mokee.settings.device;

import org.mokee.internal.util.FileUtils;

import java.util.HashMap;
import java.util.Map;

public class Constants {

    // Preference keys
    public static final String BUTTON_SWAP_KEY = "button_swap";
    public static final String PALM_SLEEP_KEY = "palm_sleep";

    public static final String FREQ_BOOT_APPLY = "freq_boot_apply";

    // Nodes
    public static final String BUTTON_SWAP_PROP = "persist.gesture.swapbuttons";
    public static final String PALM_SLEEP_PROP = "persist.gesture.palmsleep";

    // Holds <preference_key> -> <proc_node> mapping
    public static final Map<String, SwitchPreferenceBackend> sBackendsMap = new HashMap<>();

    static {
        sBackendsMap.put(BUTTON_SWAP_KEY,
                new SwitchPreferencePropBackend(BUTTON_SWAP_PROP, false));
        sBackendsMap.put(PALM_SLEEP_KEY,
        	    new SwitchPreferencePropBackend(PALM_SLEEP_PROP, false));
    }
}
