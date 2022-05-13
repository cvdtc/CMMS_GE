import React, { useState } from 'react';
/// import react router dom
import { useNavigate } from "react-router-dom";

/// combobox react for load data mesin
import AsyncSelect from 'react-select/async'
import Select from 'react-select'

/// import axios
import axios from '../../../utils/server';

/// import navigation bar
import NavbarComponent from "../../../components/Navbar";

const loadShift = [
    { value: '1', label: 'Shift 1' },
    { value: '2', label: "Shift 2" },
    { value: '3', label: "Shift 3" }
]

const loadTipeActivity = [
    { value: 'Masalah', label: 'Masalah' },
    { value: 'Maintenance', label: "Maintenance" }
]

const AddActivity = () => {

    const [idMesin, setIdMesin] = useState('')
    const [tanggal, setTanggal] = useState('')
    const [jam, setJam] = useState('')
    const [shift, setShift] = useState('1')
    const [tipe, setTipe] = useState('')
    const [deskripsi, setDeskripsi] = useState('')
    const [flagbutton, setFlagButton] = useState(true)

    /// form validate
    const [validation, setValidation] = useState([]);
    /// previous page handler
    const history = useNavigate()

    const simpanActivity = async (e) => {
        e.preventDefault();
        setFlagButton(false)
        const dataactivity = {
            idmesin: idMesin,
            tanggal: tanggal,
            jam: jam,
            shift: shift,
            jenis_masalah: tipe,
            masalah: deskripsi,
            flag_activity: '1'
        }
        console.log(dataactivity, localStorage.getItem("token"))
        await axios
            .post("masalah", dataactivity, {
                headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
            })
            .then((response) => {
                console.log(response)
                setValidation("");
                history("/dataactivity");
            })
            .catch((error) => {
                /// if response fail will be catch error message
                setValidation(error.response.data);
                console.log(error)
                setFlagButton(true)
            });
    }

    /// getting data mesin from api for dropdown mesin
    const loadMesin = () => {
        return axios.get("mesin/0", {
            headers: { Authorization: `Bearer ` + localStorage.getItem("token") },
        }).then((response) => {
            const respon = response.data.data
            console.log(respon)
            return respon
        }).catch((error) => {
            console.log(error)
        }).finally(() => {
        })
    }

    return (
        <>
            {/* /// navigation bar */}
            <NavbarComponent />
            <div className="md:container lg:mx-auto  mt-3">
                {/* /// name page */}
                <h1 className="text2xl font-medium text-gray-500 mt-4 mb-12 text-left">
                    Buat Activity
                </h1>
                {/* <div className='block p-6 rounded-lg shadow-md bg-white max-w-md'> */}
                {/* /// form design */}
                <form className='w-full' onSubmit={simpanActivity}>
                    {/* /// row 1 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// combo box mesin */}
                        <div className='w-full md:w-1/3 px-3 mb-6 md:mb-0'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Mesin</label>
                            <div className='relative'>
                                {/* <AsyncSelect className='block appearance-none w-full bg-gray-200 border border-gray-200 text-gray-700 py-3 px-4 pr-8 rounded leading-tight focus:outline-none focus:bg-white focus:border-gray-500' */}
                                <AsyncSelect
                                    cacheOptions
                                    defaultOptions
                                    getOptionLabel={e => e.nomesin + " - " + e.keterangan}
                                    getOptionValue={e => e.idmesin}
                                    loadOptions={loadMesin}
                                    placeholder="Pilih Mesin..."
                                    onChange={(value) => {
                                        setIdMesin(value.idmesin)
                                        console.log(idMesin)
                                    }}
                                />
                            </div>
                        </div>
                        {/* /// input tanggal activity */}
                        <div className='w-full md:w-1/3 px-3 mb-6 md:mb-0'>
                            <div className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>
                                <label>Tanggal Activity</label>
                                <input
                                    required
                                    type="date"
                                    className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                    placeholder='Pilih Tanggal'
                                    values={tanggal}
                                    onChange={(e) => setTanggal(e.target.value)} />
                            </div>
                        </div>
                        {/* /// input jam activity */}
                        <div className='w-full md:w-1/3 px-3 mb-6 md:mb-0'>
                            <div className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>
                                <label>Jam Activity</label>
                                <input
                                    required
                                    type="time"
                                    className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                    placeholder='Pilih Jam'
                                    values={jam}
                                    onChange={(e) => setJam(e.target.value)} />
                            </div>
                        </div>
                    </div>
                    {/* /// row 2 */}
                    <div className='flex flex-wrap -mx-3 mb-8'>
                        {/* /// input shift activity */}
                        <div className='w-full md:w-1/2 px-3 mb-6 md:mb-0'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Shift</label>
                            <div className='relative'>
                                <Select
                                    required
                                    options={loadShift}
                                    getOptionValue={e => e.value}
                                    placeholder="Pilih Shift..."
                                    onChange={(value) => {
                                        setShift(value.value)
                                    }} />
                            </div>
                        </div>
                        {/* /// combo tipe activity */}
                        <div className='w-full md:w-1/2 px-3 mb-6 md:mb-0'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Tipe Activity</label>
                            <div className='relative'>
                                <Select
                                    required
                                    options={loadTipeActivity}
                                    getOptionValue={e => e.value}
                                    placeholder="Pilih Tipe Activity..."
                                    onChange={(value) => {
                                        setTipe(value.label)
                                    }} />
                            </div>
                        </div>
                    </div>
                    {/* /// row 3 */}
                    <div className='flex flex-wrap -mx-3 mb-6'>
                        {/* /// input keterangan */}
                        <div className='w-full px-3'>
                            <label className='block uppercase tracking-wide text-gray-700 text-xs font-bold mb-2'>Deskripsi</label>
                            <input
                                required
                                type="text"
                                className='block w-full bg-gray-100 text-gray-700 border border-gray-200 py-3 px-4 rounded leading-tight focus:outline-none focus:bg-white'
                                placeholder='Keterangan'
                                values={deskripsi}
                                onChange={(e) => setDeskripsi(e.target.value)} />
                        </div>
                    </div>
                    {/* /// button simpan */}
                    <button type='submit' className='w-full h-12 px-6 text-red-50 transition-colors duration-150 bg-blue-600 rounded-lg focus:shadow-outline hover:bg-blue-600' disabled={flagbutton === false ? true : false}>Simpan</button>
                </form>
                {/* </div> */}
            </div>
        </>
    );
}

export default AddActivity;

